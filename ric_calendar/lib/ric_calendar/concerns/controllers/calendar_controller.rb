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
						fullevents = []

						# Add events from calendars
						fullevents += load_calendars(start_date, end_date)

						# Add aditional events
						fullevents += load_events(start_date, end_date)

						# Return JSON response
						render json: fullevents
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
					fullevents = []

					RicCalendar.calendar_model.all.each do |calendar|
						# Get calendar color and action edit method
						calendar_color = calendar.color unless calendar.color.blank?
						calendar_show_action = self.method(calendar.show_action) unless calendar.show_action.blank?
						calendar_edit_action = self.method(calendar.edit_action) unless calendar.edit_action.blank?

						# Go through scheduled calendar events
						calendar.events.schedule(start_date, end_date).each do |scheduled_event|

							# Create Fullcalendar event object
							fullevent = {
								id: "#{calendar.model}<#{scheduled_event[:event].id}>",
								objectId: scheduled_event[:event].id,
								start: scheduled_event[:event].start_datetime(scheduled_event[:start_date]),
								end: scheduled_event[:event].end_datetime(scheduled_event[:end_date]),
								allDay: scheduled_event[:all_day],
							}

							# Update object by calendar specific attributes
							if calendar_color
								# Color events
								fullevent[:borderColor] = calendar.color
								fullevent[:backgroundColor] = calendar.color
							end
							if calendar_show_action
								fullevent[:url] = calendar_show_action.call(scheduled_event[:event].id)
							end
							if calendar_edit_action && !scheduled_event[:is_recurring]
								# Edit events (currently only simple non-repeating events)
								fullevent[:editable] = true
								fullevent[:editUrl] = calendar_edit_action.call(scheduled_event[:event].id)
							end


							# Update object by class specific attributes
							scheduled_event[:event].into_fullcalendar(fullevent)

							# Insert into events
							fullevents << fullevent

						end
					end

					return fullevents
				end


			end
		end
	end
end