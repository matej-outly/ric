# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module CalendarEvent extend ActiveSupport::Concern

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					belongs_to :source_event, class_name: RicCalendar.calendar_event_model.to_s, foreign_key: "source_event_id"

					before_save do
						# Recurrence select sets "null" string instead of real null
						if self.recurrence_rule == "null"
							self.recurrence_rule = nil
						end
					end
				end

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:title,
							:description,

							:start_date,
							:start_time,
							:end_date,
							:end_time,
							:all_day,
							:source_event_id,

							:recurrence_rule,
						]

					end

					# *************************************************************************
					# Queries
					# *************************************************************************

					#
					# Return all events between given dates
					#
					def schedule(start_date, end_date)
						where("start_date >= ? AND end_date <= ?", start_date, end_date)
					end

				end

				# *************************************************************************
				# Recurrence
				# *************************************************************************

				# *************************************************************************
				# Methods
				# *************************************************************************

				def start_datetime
					if self.start_time
						self.start_date.to_datetime + self.start_time.seconds_since_midnight.seconds
					else
						self.start_date.to_datetime
					end
				end

				def end_datetime
					if self.end_time
						self.end_date.to_datetime + self.end_time.seconds_since_midnight.seconds
					else
						self.end_date.to_datetime
					end
				end

				def occurrences(start_date, end_date)
					rule = RecurringSelect.dirty_hash_to_rule(self.recurrence_rule)

					schedule = IceCube::Schedule.new(self.start_date)
					schedule.add_recurrence_rule(rule.until(self.end_date))
					return schedule.occurrences_between(start_date, end_date, spans: true)
				end


				# *************************************************************************
				# Conversions
				# *************************************************************************

				def to_fullcalendar
					{
						id: "RicCalendar::CalendarEvent<#{self.id}>",
						objectId: self.id,
						title: self.title,
						start: self.start_datetime,
						end: self.end_datetime,
						allDay: self.all_day,
					}
				end


			end

		end
	end
end