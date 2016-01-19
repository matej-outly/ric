# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module Event extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# One-to-many relation with event modifiers
					#
					has_many :event_modifiers, class_name: RicReservation.event_modifier_model.to_s, dependent: :destroy

					#
					# One-to-many relation with resources
					#
					belongs_to :resource, class_name: RicReservation.resource_model.to_s

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
					validates_presence_of :name, :resource_id, :capacity, :from, :to, :period

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
					# STI
					# *********************************************************

					#
					# Define scope for each available type
					#
					if config(:types)
						config(:types).each do |type|
							scope type.to_snake.pluralize.to_sym, -> { where(type: type) }
						end
					end

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
					enum_column :color, ["yellow", "turquoise", "blue", "pink", "violet", "orange", "red", "green"], default: "yellow"

				end

				module ClassMethods
					
					# *********************************************************
					# STI
					# *********************************************************

					#
					# Get available STI types
					#
					def types
						config(:types)
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

					#def overlaps_with_event(event)
					#	where(
					#		"
					#			(#{ActiveRecord::Base.connection.quote_column_name("period")} = :period_once) AND 
					#			(#{ActiveRecord::Base.connection.quote_column_name("from")} < :to) AND 
					#			(:from < #{ActiveRecord::Base.connection.quote_column_name("to")})
					#		", 
					#		from: event.from, 
					#		to: event.to, 
					#		period_once: "once"
					#	)
					#end

					# *********************************************************
					# Reservation
					# *********************************************************

					def with_reservation_by(owner)
						if owner.nil?
							all
						else
							joins("LEFT OUTER JOIN reservations ON reservations.event_id = events.id").where(reservations: { owner_id: owner.id }).group("events.id")
						end
					end

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
				# Time windows
				# *************************************************************

				#
				# Get time window soon
				#
				def time_window_soon
					value = read_attribute(:time_window_soon)
					if value.nil? && self.resource
						value = self.resource.time_window_soon
					end
					return value
				end

				#
				# Get time window deadline
				#
				def time_window_deadline
					value = read_attribute(:time_window_deadline)
					if value.nil? && self.resource
						value = self.resource.time_window_deadline
					end
					return value
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
						result += I18n.t("activerecord.attributes.ric_reservation/event.day_values.#{day}") + " "
					elsif self.period == "odd_week"
						day = days[self.from.to_datetime.cwday - 1]
						result += I18n.t("activerecord.attributes.ric_reservation/event.day_values.odd_#{day}") + " "
					elsif self.period == "even_week"
						day = days[self.from.to_datetime.cwday - 1]
						result += I18n.t("activerecord.attributes.ric_reservation/event.day_values.even_#{day}") + " "
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
				# Schedule to a specific date
				#
				def _schedule(date)
					
					# Save
					self.schedule_date = date

					# Convert from/to to DateTime
					from_utc = self.from.utc
					to_utc = self.to.utc
					
					# Schedule to exact time in given date
					self.schedule_from = DateTime.new(
						date.year, 
						date.month, 
						date.mday, 
						from_utc.strftime("%k").to_i, # hour
						from_utc.strftime("%M").to_i, # minute
						from_utc.strftime("%S").to_i # second
					).in_time_zone(Time.zone)
					self.schedule_from += (self.from.strftime("%:z").to_i - self.schedule_from.strftime("%:z").to_i).hours
					
					# Schedule to exact time in given date
					self.schedule_to = DateTime.new(
						date.year, 
						date.month, 
						date.mday, 
						to_utc.strftime("%k").to_i, # hour
						to_utc.strftime("%M").to_i, # minute
						to_utc.strftime("%S").to_i # second
					).in_time_zone(Time.zone)
					self.schedule_to += (self.to.strftime("%:z").to_i - self.schedule_to.strftime("%:z").to_i).hours

					return self
				end

				#
				# Is event scheduled
				#
				def scheduled?
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
						now = Time.current
						
						# Break points
						if self.time_window_deadline
							deadline = self.schedule_from - self.time_window_deadline.seconds_since_midnight.seconds
						else
							deadline = self.schedule_from
						end
						if self.time_window_soon
							soon = deadline - self.time_window_soon.seconds_since_midnight.seconds
						else
							soon = deadline
						end

						# State recognititon
						if now < soon
							@state = :open
						elsif now < deadline
							@state = :soon
						elsif now < self.schedule_from
							@state = :deadline
						else
							@state = :closed
						end
					end
					return @state
				end

				# *************************************************************
				# Reservations
				# *************************************************************

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
				# Get current (scheduled) event size
				#
				def size
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
					reservation.event_id = self.id
					reservation.schedule_date = self.schedule_date
					reservation.schedule_from = self.schedule_from
					reservation.schedule_to = self.schedule_to

					# Bind subject
					reservation.size = subject.size
					reservation.subject = subject
					
					# Bind owner
					if !owner.nil?
						reservation.owner_id = owner.id if !owner.id.nil?
						reservation.owner_name = owner.name if !owner.name.nil?
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
							self.from = DateTime.new(
								date.year, 
								date.month, 
								date.mday, 
								time_from.utc.strftime("%k").to_i, # hour
								time_from.utc.strftime("%M").to_i, # minute
								time_from.utc.strftime("%S").to_i # second
							).in_time_zone(Time.zone)
							self.from += (time_from.strftime("%:z").to_i - self.from.strftime("%:z").to_i).hours
						end
						if !time_to.nil?
							self.to = DateTime.new(
								date.year, 
								date.month, 
								date.mday, 
								time_to.utc.strftime("%k").to_i, # hour
								time_to.utc.strftime("%M").to_i, # minute
								time_to.utc.strftime("%S").to_i # second
							).in_time_zone(Time.zone)
							self.to += (time_to.strftime("%:z").to_i - self.to.strftime("%:z").to_i).hours
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

			end
		end
	end
end