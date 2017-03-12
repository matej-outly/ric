# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Schedulable
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Schedulable extend ActiveSupport::Concern

				module ClassMethods

					# *********************************************************
					# Queries
					# *********************************************************

					#
					# Return all events between given dates
					#
					def between(date_from, date_to)
						where("date_from >= ? AND date_to <= ?", date_from, date_to)
					end

					#
					# Return all occurences of events in dates
					#
					def schedule(date_from, date_to)
						scheduled_events = []

						between(date_from, date_to).each do |event|

							scheduled_event_base = {
								event: event,
								time_from: event.time_from,
								time_to: event.time_to,
								all_day: event.all_day,
								is_recurring: false,
							}

							if !event.is_recurring?
								# Regular event
								scheduled_event_base[:date_from] = event.date_from
								scheduled_event_base[:date_to] = event.date_to
								scheduled_events << scheduled_event_base

							else
								# Recurring event
								event.occurrences(date_from, date_to).each do |occurence|
									scheduled_event = scheduled_event_base.clone
									scheduled_event[:date_from] = occurence.start_time.to_date
									scheduled_event[:date_to] = occurence.end_time.to_date
									scheduled_event[:is_recurring] = true
									scheduled_event[:recurrence_template_id] = event.id
									scheduled_events << scheduled_event
								end

							end
						end

						return scheduled_events
					end

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns_for_schedulable
						[
							:date_from,
							:time_from,
							:date_to,
							:time_to,
							:all_day,
						]
					end

				end

				# *************************************************************
				# Recurring
				# *************************************************************

				def is_recurring?
					self.has_attribute?(:recurrence_rule) && !self.recurrence_rule.nil?
				end

				# *************************************************************
				# Date and time
				# *************************************************************

				#
				# Make DateTime object from (given) Date and Time objects
				#
				def datetime_from(base_date = self.date_from)
					if self.time_from
						base_date.to_datetime + self.time_from.seconds_since_midnight.seconds
					else
						base_date.to_datetime
					end
				end

				#
				# Make DateTime object from (given) Date and Time objects
				#
				def datetime_to(base_date = self.date_to)
					if self.time_to
						base_date.to_datetime + self.time_to.seconds_since_midnight.seconds
					else
						base_date.to_datetime
					end
				end

				# *************************************************************
				# Conversions
				# *************************************************************

				#
				# This method must be implemented in model:
				#

				# def to_fullcalendar(fullevent)
				#	fullevent[:title] = self.name
				# end

			end

		end
	end
end