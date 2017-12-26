# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event - capacity, event reservation state, etc.
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module Event extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					#
					# One-to-many relation with event modifiers
					#
					has_many :event_modifiers, foreign_key: "event_id", class_name: RicReservation.event_modifier_model.to_s, dependent: :destroy

					#
					# One-to-many relation with reservations
					#
					#has_many :reservations, class_name: RicReservation.reservation_model.to_s
					# TODO dependent: :destroy

					# *********************************************************
					# Validators
					# *********************************************************
					
					#
					# Some columns must be present
					#
					validates_presence_of :name, :capacity, :from, :to, :period

					#
					# From / to times must be consistent
					#
					validate :validate_from_to_consistency

					# *********************************************************
					# Validity
					# *********************************************************

					#
					# Correct valid from must be set before save
					#
					before_save :set_valid_from_before_save

					# *********************************************************
					# Period
					# *********************************************************

					#
					# Period
					#
					enum_column :period, ["day", "workday", "weekendday", "week", "odd_week", "even_week", "once"]

					# *************************************************************
					# Time
					# *************************************************************

					#
					# Virtual attributes
					#
					attr_writer :date
					attr_writer :time_from
					attr_writer :time_to

					#
					# Correct from/to must be set before save
					#
					before_validation :set_from_to_before_validation

					#
					# Copy validation errors
					#
					after_validation :copy_from_to_errors_after_validation

					# *********************************************************
					# Schedule
					# *********************************************************

					#
					# Virtual attributes
					#
					attr_accessor :schedule_date
					attr_accessor :schedule_from
					attr_accessor :schedule_to

					# *********************************************************
					# Reservations
					# *********************************************************

					#
					# All existing reservations must be synchronizied wih the data update
					#
					before_save :synchronize_reservations_before_save

					# *********************************************************
					# Color
					# *********************************************************

					#
					# Period
					#
					enum_column :color, ["yellow", "turquoise", "blue", "pink", "violet", "orange", "red", "green", "grey"], default: "yellow"

					# *********************************************************
					# Time windows / states
					# *********************************************************

					#
					# Define time windows as duration
					# 
					if config(:states) 
						if config(:state_policy) == "time_fixed"
							config(:states).each_with_index do |state_spec, index|
								if index != 0

									# Column name
									new_column = "time_fixed_#{state_spec[:name]}".to_sym

									# Redefine getter
									define_method(new_column) do
										column = new_column
										value = read_attribute(column)
										if value.nil? && self.resource
											value = self.resource.send(column)
										end
										return value
									end

								end
							end
						else
							config(:states).each_with_index do |state_spec, index|
								if index != 0 && index != config(:states).length

									# Column name
									new_column = "time_window_#{state_spec[:name]}".to_sym

									# Duration column
									duration_column new_column 

									# Redefine getter
									define_method(new_column) do
										column = new_column
										value = read_attribute(column)
										if value.nil? && self.resource
											value = self.resource.send(column)
										end
										return value
									end

									# Redefine formatted getter
									define_method((new_column.to_s + "_formatted").to_sym) do
										column = new_column
										if read_attribute(column.to_s).nil? && self.resource
											return self.resource.send(new_column.to_s + "_formatted")
										else
											value = read_attribute(column.to_s)
											return nil if value.blank?
											days = value.days_since_new_year
											hours = value.hour
											minutes = value.min
											seconds = value.sec
											result = []
											result << days.to_s + " " + I18n.t("general.attribute.duration.days").downcase_first if days > 0
											result << hours.to_s + " " + I18n.t("general.attribute.duration.hours").downcase_first if hours > 0
											result << minutes.to_s + " " + I18n.t("general.attribute.duration.minutes").downcase_first if minutes > 0
											result << seconds.to_s + " " + I18n.t("general.attribute.duration.seconds").downcase_first if seconds > 0
											return result.join(", ")
										end
									end

								end
							end
						end
					end

					#
					# State
					#
					state_column :state, config(:states).map { |state_spec| state_spec[:name] }

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Columns permitted to be updated via request
					#
					def permitted_columns
						result = []
						if config(:states)
							if config(:state_policy) == "time_fixed"
								config(:states).each_with_index do |state_spec, index|
									result << "time_fixed_#{state_spec[:name]}".to_sym if index != 0
								end
							else
								config(:states).each_with_index do |state_spec, index|
									result << "time_window_#{state_spec[:name]}".to_sym if index != 0 && index != config(:states).length
								end
							end
						end	
						result << :resource_id
						result << :name
						result << :color
						result << :from
						result << :to
						result << :period
						result << :capacity
						result << :owner_reservation_limit
						return result
					end

					# *********************************************************
					# Resource
					# *********************************************************

					#
					# Get resource id column name - to be overriden in model
					#
					def resource_id_column
						raise "Not implemented."
					end

					#
					# Get resource type - to be overriden in model
					#
					def resource_type
						raise "Not implemented."
					end

					# *********************************************************
					# Validity
					# *********************************************************

					#
					# Scope for yet invalid events
					#
					def yet_invalid(date)
						where("valid_from > :date", date: date)
					end

					#
					# Scope for already invalid events
					#
					def already_invalid(date)
						where("valid_to <= :date", date: date)
					end

					#
					# Scope for valid events
					#
					def valid(date_from, date_to = nil)
						date_to = date_from + 1.day if date_to.nil?
						where("(valid_from < :date_to OR valid_from IS NULL) AND (:date_from < valid_to OR valid_to IS NULL)", date_from: date_from, date_to: date_to)
					end

					# *********************************************************
					# Schedule
					# *********************************************************

					#
					# Compute schedule from and schedule to according to period, page and anchor date
					#
					# If reverse flag is set to true, pagination is computed to past instead of future
					#
					def schedule_paginate(date, period, page, reverse = false)
						 
						# Correct page
						if !page.nil?
							page = page.to_i
						else
							page = 1
						end

						# Correct period
						if period.nil?
							period = "week"
						end

						if period == "week"

							# From
							from = date + (1 - date.cwday).days # Monday before date

							# Pagination
							if reverse == true
								from = from - (page - 1).week
							else
								from = from + (page - 1).week
							end
							
							# To
							to = from + 1.week

						elsif period == "month"

							# From
							from = date + (1 - date.mday).days # First day of this month

							# Pagination
							if reverse == true
								from = from - (page - 1).month
							else
								from = from + (page - 1).month
							end

							# To
							to = from + 1.month

						 end

						 return [from, to, period, page]
					end

					#
					# Duplicate given events to schedule and set correct schedule date
					#
					def schedule_events(schedule_from, schedule_to, events)

						result = []

						events.each do |event|

							if event.period == "day"

								# Find first day of schedule range
								schedule_date = schedule_from

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.day
								end
								while schedule_date < schedule_to

									scheduled_event = event.clone
									scheduled_event._schedule(schedule_date)
									result << scheduled_event
									
									schedule_date = schedule_date + 1.day
								end

							elsif event.period == "workday"

								# Find first day of schedule range which is monday (cwday == 1)
								schedule_date = schedule_from + (1 - schedule_from.cwday).days

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.day
								end
								while schedule_date < schedule_to

									if schedule_date.cwday != 6 && schedule_date.cwday != 7 # Not saturday and not sunday
										scheduled_event = event.clone
										scheduled_event._schedule(schedule_date)
										result << scheduled_event
									end

									schedule_date = schedule_date + 1.day
								end

							elsif event.period == "weekendday"

								# Find first day of schedule range which is saturday (cwday == 6)
								schedule_date = schedule_from + (6 - schedule_from.cwday).days

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.day
								end
								while schedule_date < schedule_to

									if schedule_date.cwday == 6 || schedule_date.cwday == 7 # Saturday or sunday
										scheduled_event = event.clone
										scheduled_event._schedule(schedule_date)
										result << scheduled_event
									end

									schedule_date = schedule_date + 1.day
								end

							elsif event.period == "week"
								
								# Calendar week day
								cwday = event.from.to_datetime.cwday

								# Find first day of schedule range with similar cwday
								schedule_date = schedule_from + (cwday - schedule_from.cwday).days

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.week
								end
								while schedule_date < schedule_to

									scheduled_event = event.clone
									scheduled_event._schedule(schedule_date)
									result << scheduled_event

									schedule_date = schedule_date + 1.week
								end

							elsif event.period == "odd_week"
								
								# Calendar week day
								cwday = event.from.to_datetime.cwday

								# Find first day of schedule range with similar cwday
								schedule_date = schedule_from + (cwday - schedule_from.cwday).days

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.week
								end
								while schedule_date < schedule_to

									if (schedule_date.cweek % 2) == 1 # Odd calendar week
										scheduled_event = event.clone
										scheduled_event._schedule(schedule_date)
										result << scheduled_event
									end

									schedule_date = schedule_date + 1.week
								end

							elsif event.period == "even_week"
								
								# Calendar week day
								cwday = event.from.to_datetime.cwday

								# Find first day of schedule range with similar cwday
								schedule_date = schedule_from + (cwday - schedule_from.cwday).days

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.week
								end
								while schedule_date < schedule_to

									if (schedule_date.cweek % 2) == 0 # Even calendar week
										scheduled_event = event.clone
										scheduled_event._schedule(schedule_date)
										result << scheduled_event
									end

									schedule_date = schedule_date + 1.week
								end

							elsif event.period == "month"

								# TODO

							elsif event.period == "once"

								# Find first day of schedule range
								schedule_date = schedule_from

								# Copy event to all matching days in schedule
								while schedule_date < schedule_from
									schedule_date = schedule_date + 1.day
								end
								while schedule_date < schedule_to

									if schedule_date == event.from.to_date
										scheduled_event = event.clone
										scheduled_event._schedule(schedule_date)
										result << scheduled_event
									end
									
									schedule_date = schedule_date + 1.day
								end

							end

						end

						return result
					end

					# *********************************************************
					# Overlapping TODO: Other periods than ONCE
					# *********************************************************

					def overlaps_with_resource_reservation(resource_reservation)
						where(
							"
								(#{ActiveRecord::Base.connection.quote_column_name("period")} = :period_once) AND 
								(#{ActiveRecord::Base.connection.quote_column_name("from")} < :to) AND 
								(:from < #{ActiveRecord::Base.connection.quote_column_name("to")})
							", 
							from: resource_reservation.schedule_from, 
							to: resource_reservation.schedule_to, 
							period_once: "once"
						)
					end

					# *********************************************************
					# Reservation
					# *********************************************************

					def with_reservation_by(owner)
						if owner.nil?
							all
						else
							joins("LEFT OUTER JOIN reservations ON reservations.event_id = #{self.table_name}.id AND reservations.event_type = #{ActiveRecord::Base.connection.quote(self.name)}")
								.where(reservations: { owner_id: owner.id, owner_type: owner.class.name })
								.group("#{self.table_name}.id")
						end
					end

				end

				# *************************************************************
				# Resource
				# *************************************************************

				#
				# Get resource id
				#
				def resource_id
					return self.send(self.class.resource_id_column)
				end

				#
				# Get resource type
				#
				def resource_type
					return self.class.resource_type
				end

				#
				# Get resource object
				#
				def resource
					if @resource.nil?
						begin
							@resource = self.resource_type.constantize.find_by_id(self.resource_id)
						rescue
						end
					end
					return @resource
				end

				# *************************************************************
				# Validity
				# *************************************************************

				#
				# Make event already invalid (should be used instead of destroy)
				#
				def invalidate(date)
					self.valid_to = date
					self.save
				end

				#
				# Is event yet invalid?
				#
				def is_yet_invalid?(date)
					return !self.valid_from.nil? && self.valid_from > date
				end

				#
				# Is event already invalid?
				#
				def is_already_invalid?(date)
					return !self.valid_to.nil? && self.valid_to <= date
				end

				#
				# Is event valid?
				#
				def is_valid?(date_from, date_to = nil)
					date_to = date_from + 1.day if date_to.nil?
					return (self.valid_from.nil? || self.valid_from < date_to) && (self.valid_to.nil? || date_from < self.valid_to)
				end

				# *************************************************************
				# Period
				# *************************************************************

				#
				# System should view the resource in scope of one month
				#
				def month_scope_period?
					return self.period == "week" || self.period == "odd_week" || self.period == "even_week" || self.period == "month" || self.period == "once"
				end

				# *************************************************************
				# Owner reservation limit
				# *************************************************************

				#
				# Get owner reservation limit
				#
				def owner_reservation_limit
					value = read_attribute(:owner_reservation_limit)
					if value.nil? && self.resource
						value = self.resource.owner_reservation_limit
					end
					return value
				end

				# *************************************************************
				# Time
				# *************************************************************

				def date
					if self.from
						return self.from.to_date
					else
						return @date
					end
				end

				def time_from
					if self.from
						return self.from
					else
						return @time_from
					end
				end

				def time_to
					if self.to
						return self.to
					else
						return @time_to
					end
				end

				#
				# From / to time translated to human language according to period
				#
				def formatted_time
					result = ""
					days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
					if self.period == "week"
						day = days[self.from.to_datetime.cwday - 1]
						result += I18n.t("date.days.#{day}") + " "
					elsif self.period == "odd_week"
						day = days[self.from.to_datetime.cwday - 1]
						result += I18n.t("date.days.odd_#{day}") + " "
					elsif self.period == "even_week"
						day = days[self.from.to_datetime.cwday - 1]
						result += I18n.t("date.days.even_#{day}") + " "
					elsif self.period == "month"
						result += self.from.strftime("%-d. ")
					elsif self.period == "once"
						result += self.from.strftime("%-d. %-m. %Y ")
					end
					result += self.from.strftime("%k:%M") + " - " + self.to.strftime("%k:%M")
					return result
				end

				# *************************************************************
				# Schedule
				# *************************************************************

				#
				# Schedule to a specific date 
				#
				# TODO check if date is correct
				#
				def schedule(date)
					
					return _schedule(date)

				end

				#
				# Is event scheduled
				#
				def scheduled?
					if self.schedule_date.nil?
						self.automatic_schedule_if_possible
					end
					return !self.schedule_date.nil?
				end

				#
				# Schedule time
				#
				def schedule_formatted_time
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					return self.schedule_from.strftime("%k:%M") + " - " + self.schedule_to.strftime("%k:%M")
				end

				#
				# Schedule to a specific date
				#
				def _schedule(date)
					
					# Save
					self.schedule_date = date

					# Schedule to exact time in given date
					self.schedule_from = DateTime.compose(date, self.from)
					
					# Schedule to exact time in given date
					self.schedule_to = DateTime.compose(date, self.to)
					
					return self
				end

				# *************************************************************
				# State
				# *************************************************************

				#
				# Get state according to date
				#
				def state
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					if @state.nil?
						
						# Now
						now = Time.current
						
						# States
						states = config(:states)

						# Break times
						if config(:state_policy) == "time_fixed"
							break_times = []
							states.reverse_each_with_index do |state_spec, index|
								if index != 0 # Do not consider first state
									state_name = state_spec[:name]
									time_fixed = self.send("time_fixed_#{state_name}")
									if time_fixed
										break_times << time_fixed
									else
										break_times << break_times.last
									end
								end
							end
						else
							break_times = [self.schedule_from]
							states.reverse_each_with_index do |state_spec, index|
								if index != 0 && index != (states.length - 1) # Do not consider first and last state
									state_name = state_spec[:name]
									time_window = self.send("time_window_#{state_name}")
									if time_window
										break_times << (break_times.last - time_window.days_since_new_year.days - time_window.seconds_since_midnight.seconds)
									else
										break_times << break_times.last
									end
								end
							end
						end
						
						# State recognititon
						states.each_with_index do |state_spec, index|
							if index < states.length - 1
								if !break_times[states.length - 2 - index].nil? && now < break_times[states.length - 2 - index]
									@state = state_spec[:name].to_sym
									@state_behavior = state_spec[:behavior].to_sym
									break
								end
							else # Last fallback state
								@state = state_spec[:name].to_sym
								@state_behavior = state_spec[:behavior].to_sym
								break
							end
						end
					end
					return @state
				end

				#
				# Get state behavior according to current date and time
				#
				def state_behavior
					if @state_behavior.nil?
						self.state
					end
					return @state_behavior
				end

				# *************************************************************
				# Reservations
				# *************************************************************

				#
				# Default capacity kind
				# 
				def capacity_type
					:integer
				end

				#
				# Default reservation size set if no subject defined
				#
				def default_reservation_size
					1
				end

				#
				# Get all reservations 
				#
				def reservations
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					return RicReservation.reservation_model.event(self, self.schedule_date)
				end

				#
				# Create new reservation for given owner
				#
				def create_reservation(subject, owner = nil, force_state = false)
					if !scheduled?
						raise "Schedule event to specific date first."
					end

					# State check
					#if force_state != true && state == :closed
					#	return nil
					#end
					
					# Create reservation
					reservation = _create_resevation(subject, owner)

					# Store
					reservation.save

					return reservation
				end

				#
				# Validate new reservation for given owner
				#
				def validate_reservation(subject, owner = nil, force_state = false)
					if !scheduled?
						raise "Schedule event to specific date first."
					end

					# State check
					#if force_state != true && state == :closed
					#	return nil
					#end
					
					# Create reservation
					reservation = _create_resevation(subject, owner)

					# Validate
					reservation.valid?

					return reservation
				end

				#
				# Get current event size in case capacity/size type is integer
				#
				def size_integer
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					if @size.nil?
						@size = 0
						self.reservations.each do |reservation|
							if reservation.above_line?
								@size += reservation.size
							end
						end
					end
					return @size
				end

				#
				# Get current event size in case capacity/size type is time
				#
				def size_time
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					if @size.nil?
						@size = DateTime.parse("2000-01-01 00:00:00 +0000")
						self.reservations.each do |reservation|
							if reservation.above_line?
								@size += reservation.size.seconds_since_midnight.seconds
							end
						end
					end
					return @size
				end

				#
				# Get current event size (based on defined capacity/size type)
				#
				def size
					return self.send("size_#{self.capacity_type.to_s}")
				end

				#
				# Get current capacity (based on defined capacity/size type)
				#
				def capacity
					return self.send("capacity_#{self.capacity_type.to_s}")
				end

				#
				# Set current capacity (based on defined capacity/size type)
				#
				def capacity=(capacity)
					self.send("capacity_#{self.capacity_type.to_s}=", capacity)
				end

				#
				# (Scheduled) event is at capacity and no other reservations can be created
				#
				def at_capacity?
					if !scheduled?
						raise "Schedule event to specific date first."
					end

					if @at_capacity.nil?
						@at_capacity = (self.size >= self.capacity)
					end
					return @at_capacity
				end

				# *************************************************************
				# Modifiers
				# *************************************************************

				#
				# Get all modifiers 
				#
				def modifiers
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					return RicReservation.event_modifier_model.where(event_id: self.id, schedule_date: self.schedule_date)
				end

				#
				# Create new modifier
				#
				def create_modifier(type)
					if !scheduled?
						raise "Schedule event to specific date first."
					end

					# Create modifier
					modifier = RicReservation.event_modifier_model.new
					modifier.event_id = self.id
					modifier.schedule_date = self.schedule_date

					# Type
					if type == :tmp_canceled
						modifier.tmp_canceled = true
					else
						raise "Unknown type."
					end

					# Save
					modifier.save

					return modifier
				end

				#
				# Event is canceled by tmp cancel modifier
				#
				def tmp_canceled?
					if @tmp_canceled.nil?
						@tmp_canceled_modifier = modifiers.tmp_canceled.first
						@tmp_canceled = !@tmp_canceled_modifier.nil?
					end
					return @tmp_canceled
				end

				#
				# Event is canceled by tmp cancel modifier
				#
				def tmp_canceled_modifier
					return @tmp_canceled_modifier
				end

			protected

				# *************************************************************
				# Reservations
				# *************************************************************

				#
				# Create new reservation object according to subject and owner
				#
				def _create_resevation(subject, owner = nil)
					
					# Create reservation
					reservation = RicReservation.reservation_model.new
					reservation.kind = "event"
					reservation.event = self
					reservation.schedule_date = self.schedule_date
					reservation.schedule_from = self.schedule_from
					reservation.schedule_to = self.schedule_to

					# Bind subject
					if !subject.nil?
						reservation.size = subject.size
						reservation.subject = subject
					else
						reservation.size = self.default_reservation_size
					end

					# Bind owner
					if !owner.nil?
						reservation.owner_name = owner.name if !owner.name.nil?
						reservation.owner = owner if owner.is_a?(ActiveRecord::Base) # In case owner is not ActiveRecord, only name can be stored
					end

					return reservation
				end

				#
				# All existing reservations must be synchronizied wih the data update
				#
				def synchronize_reservations_before_save
					if self.period_was == "once"
						self.schedule(self.from_was.to_date)
						self.reservations.each do |reservation|
							self.schedule(self.from.to_date)
							reservation.schedule_date = self.schedule_date
							reservation.schedule_from = self.schedule_from
							reservation.schedule_to = self.schedule_to
							reservation.save
						end
					else
						# TODO Other period than ONCE
					end
				end

				# *************************************************************
				# Validators
				# *************************************************************

				#
				# "From" and "to" must be same day, "from" must be before "to" (causality)
				#
				def validate_from_to_consistency

					if self.from.nil? || self.to.nil?
						return
					end

					# Same day
					if self.from.to_date != self.to.to_date
						errors.add(:to, I18n.t("activerecord.errors.models.#{RicReservation.event_model.model_name.i18n_key}.attributes.to.different_day_than_from"))
					end

					# Causality
					if self.from >= self.to
						errors.add(:to, I18n.t("activerecord.errors.models.#{RicReservation.event_model.model_name.i18n_key}.attributes.to.before_from"))
					end

				end

				# *************************************************************
				# Validity
				# *************************************************************

				#
				# Set correct valid from time
				#
				def set_valid_from_before_save
					self.valid_from = self.from.to_date
				end

				# *************************************************************
				# Time
				# *************************************************************

				#
				# Set correct from/to if virtual date, time_from and time_to attributes set
				#
				def set_from_to_before_validation
					
					# Date
					if @date.blank?
						date = nil
					elsif @date.is_a?(::String)
						date = Date.parse(@date)
					else
						date = @date
					end

					# From
					if @time_from.blank?
						time_from = nil
					elsif @time_from.is_a?(::String)
						time_from = DateTime.parse(@time_from)
					else
						time_from = @time_from
					end

					# To
					if @time_to.blank?
						time_to = nil
					elsif @time_to.is_a?(::String)
						time_to = DateTime.parse(@time_to)
					else
						time_to = @time_to
					end

					# Compose
					if !date.nil?
						if !time_from.nil?
							self.from = DateTime.compose(date, time_from)
						end
						if !time_to.nil?
							self.to = DateTime.compose(date, time_to)
						end
					end

				end

				#
				# Copy validation errors
				#
				def copy_from_to_errors_after_validation
					errors[:from].each { |message| errors.add(:time_from, message) }
					errors[:to].each { |message| errors.add(:time_to, message) }
				end

				# *************************************************************
				# Schedule
				# *************************************************************

				#
				# Try to automatically schedule event
				#
				def automatic_schedule_if_possible
					
					if self.period == "once" # Automatic schedule is possible for events with period "once"
						self.schedule(self.from.to_date)
					
					elsif self.resource.period == "week" # Automatic schedule is possible for events in resources with period "week"
						monday = self.resource.valid_from.beginning_of_week # Monday matching to resource "valid from" date
						self.schedule(monday + (self.from.to_date.cwday - 1).days) # Schedule to the matching day in the week identified by resource "valid from" date
					end

				end

			end
		end
	end
end