# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Controllers
			module CalendarController extend ActiveSupport::Concern

				# *************************************************************************
				# Actions
				# *************************************************************************

				#
				# Show calendar as regular HTML page
				#
				def index
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				#
				# Return events in Fullcalendar format via AJAX
				#
				def events
					if can_read? || can_read_and_write?
						start_date = Date.parse(params[:start].to_s)
						end_date = Date.parse(params[:end].to_s)

						# Calendar events
						fullcalendar_events = []

						# Add events from calendars
						fullcalendar_events += load_calendars(start_date, end_date)

						# Add aditional events
						fullcalendar_events += load_events(start_date, end_date)

						# Return JSON response
						render json: fullcalendar_events
					else
						not_authorized!
					end
				end


				# *************************************************************************
				# Events
				# *************************************************************************

				#
				# Inject custom events into calendar and return list of fullcalendar objects
				#
				# Should be overrided
				#
				def load_events(start_date, end_date)
					[]
				end

			protected

				#
				# Read events from calendars
				#
				def load_calendars(start_date, end_date)
					fullcalendar_events = []

					RicCalendar.calendar_model.all.each do |calendar|
						# Get calendar color and action edit method
						calendar_color = calendar.color unless calendar.color.blank?
						calendar_edit_action = self.method(calendar.edit_action) unless calendar.edit_action.blank?

						# Go through scheduled calendar events
						calendar.events.schedule(start_date, end_date).each do |scheduled_event|

							# Create Fullcalendar event object
							fullcalendar_event = {
								id: "#{calendar.model}<#{scheduled_event[:event].id}>",
								objectId: scheduled_event[:event].id,
								start: scheduled_event[:event].start_datetime(scheduled_event[:start_date]),
								end: scheduled_event[:event].end_datetime(scheduled_event[:end_date]),
								allDay: scheduled_event[:all_day],
							}

							# Update object by calendar specific attributes
							if calendar_color
								# Color events
								fullcalendar_event[:borderColor] = calendar.color
								fullcalendar_event[:backgroundColor] = calendar.color
							end
							if calendar_edit_action && !scheduled_event[:is_recurring]
								# Edit events (currently only simple non-repeating events)
								fullcalendar_event[:editable] = true
								fullcalendar_event[:editUrl] = calendar_edit_action.call(scheduled_event[:event].id)
							end

							# Update object by class specific attributes
							scheduled_event[:event].into_fullcalendar(fullcalendar_event)

							# Insert into events
							fullcalendar_events << fullcalendar_event

						end
					end

					return fullcalendar_events
				end


			end
		end
	end
end