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
					def between(start_date, end_date)
						where("start_date >= ? AND end_date <= ?", start_date, end_date)
					end

					#
					# Return all occurences of events in dates
					#
					def schedule(start_date, end_date)
						scheduled_events = []

						between(start_date, end_date).each do |event|

							scheduled_event_base = {
								event: event,
								start_time: event.start_time,
								end_time: event.end_time,
								all_day: event.all_day,
								is_recurring: false,
							}

							if !event.has_attribute?(:recurrence_rule) || event.recurrence_rule == nil
								# Regular event
								scheduled_event_base[:start_date] = event.start_date
								scheduled_event_base[:end_date] = event.end_date
								scheduled_events << scheduled_event_base

							else
								# Recurring event
								event.occurrences(start_date, end_date).each do |occurence|
									scheduled_event = scheduled_event_base.clone
									scheduled_event[:start_date] = occurence.start_time.to_date
									scheduled_event[:end_date] = occurence.end_time.to_date
									scheduled_event[:is_recurring] = true
									scheduled_event[:recurrence_template_id] = event.id
									scheduled_events << scheduled_event
								end

							end
						end

						return scheduled_events
					end

				end


				# *************************************************************
				# Date and time
				# *************************************************************

				#
				# Make DateTime object from (given) Date and Time objects
				#
				def start_datetime(base_date = self.start_date)
					if self.start_time
						base_date.to_datetime + self.start_time.seconds_since_midnight.seconds
					else
						base_date.to_datetime
					end
				end

				#
				# Make DateTime object from (given) Date and Time objects
				#
				def end_datetime(base_date = self.end_date)
					if self.end_time
						base_date.to_datetime + self.end_time.seconds_since_midnight.seconds
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
				#	fullevent[:title] = self.title
				# end

			end

		end
	end
end