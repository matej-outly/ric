# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Controllers
			module IcalController extend ActiveSupport::Concern

				#
				# Return events in iCal format
				#
				def index
					date_from = Date.today - 1.month
					date_to = Date.today + 1.year

					# Add calendar header, however it is not neccessary at least for iPhone 4S
					headers['Content-Type'] = "text/calendar; charset=UTF-8"
					render text: load_calendars(date_from, date_to).to_ical
				end

			protected


				# *************************************************************
				# Content loading
				# *************************************************************

				#
				# Read events from calendars
				#
				def load_calendars(date_from, date_to)

					ical = Icalendar::Calendar.new

					RicCalendar.calendar_model.all.each do |calendar|

						# Go through scheduled calendar events
						calendar.resource_events.schedule(date_from, date_to).each do |scheduled_event|

							# Create iCal event
							ical.event do |e|
								e.uid = "#{request.original_url}@#{calendar.kind_options[:event_type]}<#{scheduled_event[:event].id}>[#{scheduled_event[:recurrence_id]}]"

								scheduled_from = scheduled_event[:event].datetime_from(scheduled_event[:date_from])
								scheduled_to = scheduled_event[:event].datetime_to(scheduled_event[:date_to])
								if scheduled_event[:all_day] == false
									e.dtstart = Icalendar::Values::DateTime.new(scheduled_from)
									e.dtend = Icalendar::Values::DateTime.new(scheduled_to)
								else
									e.dtstart = Icalendar::Values::Date.new(scheduled_from)
									e.dtend = Icalendar::Values::Date.new(scheduled_to)
								end

								e.summary     = scheduled_event[:event].event_title
								e.description = ""
							end

						end
					end

					return ical
				end

			end
		end
	end
end