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
					# From / to times must be consistent
					#
					validate :validate_from_to_consistency

					#
					# Some columns must be present
					#
					validates_presence_of :name, :resource_id, :capacity, :from, :to, :period

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
						 
						# Pagination
						if !page.nil?
							page = page.to_i
						else
							page = 1
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

						 return [from, to, page]
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
					if value.nil?
						value = 0
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
					if value.nil?
						value = 0
					end
					return value
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
					
					_schedule(date)

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
				def schedule_time
					if !scheduled?
						raise "Schedule event to specific date first."
					end
					return self.schedule_from.strftime("%k:%M") + " - " + self.schedule_to.strftime("%k:%M")
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
						deadline = self.schedule_from - self.time_window_deadline.minutes
						soon = deadline - self.time_window_soon.minutes

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
					return RicReservation.reservation_model.where(kind: "event", event_id: self.id, schedule_date: self.schedule_date)
				end

				#
				# Create new reservation for given owner
				#
				def create_reservation(owner = nil, size = 1, force_state = false)
					if !scheduled?
						raise "Schedule event to specific date first."
					end

					# State check
					if force_state != true && state == :closed
						return nil
					end
					
					# Create reservation
					reservation = RicReservation.reservation_model.new
					reservation.kind = "event"
					reservation.event_id = self.id
					reservation.schedule_date = self.schedule_date
					reservation.schedule_from = self.schedule_from
					reservation.schedule_to = self.schedule_to
					reservation.size = size

					# Capacity check
					if at_capacity?
						reservation.below_line = true
					end
					
					# Bind owner
					if !owner.nil?
						reservation.owner_id = owner.id if !owner.id.nil?
						reservation.owner_name = owner.name if !owner.name.nil?
					end

					# Store
					reservation.save

					return reservation
				end

				#
				# Event is at capacity and no other reservations can be created
				#
				def at_capacity?
					if @at_capacity.nil?
						size = 0
						self.reservations.each do |reservation|
							if reservation.above_line?
								size += reservation.size
							end
						end
						@at_capacity = (size >= self.capacity)
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
						errors.add(:to, I18n.t('activerecord.errors.models.event.attributes.to.different_day_than_from'))
					end

					# Causality
					if self.from >= self.to
						errors.add(:to, I18n.t('activerecord.errors.models.event.attributes.to.before_from'))
					end

				end

				# *************************************************************
				# Validity callback
				# *************************************************************

				#
				# Set correct valid from time
				#
				def set_valid_from_before_save
					self.valid_from = self.from.to_date
				end

			end
		end
	end
end