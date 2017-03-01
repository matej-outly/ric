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

				included do

					# Directory listing
					# before_action :set_files_and_folders, only: [:index, :show]

				end

				# *************************************************************************
				# Actions
				# *************************************************************************

				def index
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				def events
					if can_read? || can_read_and_write?
						start_date = Date.parse(params[:start].to_s)
						end_date = Date.parse(params[:end].to_s)

						# Calendar events
						fullcalendar_events = []

						# Add calendar events
						fullcalendar_events += load_calendar_events(start_date, end_date)

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
				# Load CalendarEvents
				#
				def load_calendar_events(start_date, end_date)
					fullcalendar_events = []

					RicCalendar.calendar_event_model.schedule(start_date, end_date).each do |calendar_event|
						if calendar_event.recurrence_rule == nil
							fullcalendar_event = calendar_event.to_fullcalendar

							# Edit simple events
							fullcalendar_event[:editable] = true
							fullcalendar_event[:editUrl] = calendar_event_path(calendar_event.id)

							# TODO: If model does not have all_day field => disable all day drag & drop
							fullcalendar_events << fullcalendar_event
						else
							base_fullcalendar_event = calendar_event.to_fullcalendar

							calendar_event.occurrences(start_date, end_date).each do |occurrence|
								fullcalendar_event = base_fullcalendar_event.clone

								fullcalendar_event[:start] = occurrence.start_time + calendar_event.start_time.seconds_since_midnight.seconds
								fullcalendar_event[:end] = occurrence.end_time + calendar_event.end_time.seconds_since_midnight.seconds

								fullcalendar_events << fullcalendar_event
							end

						end
					end

					return fullcalendar_events
				end

				#
				# Load repeated events
				#
				def load_calendar_event_templates(start_date, end_date)
					RicCalendar.calendar_event_template_model.schedule(start_date, end_date).each do |calendar_event_template|

					end
				end

				#
				# Inject custom events into calendar and return list of fullcalendar objects, should be overrided
				#
				def load_events(start_date, end_date)
					[]
				end

			end
		end
	end
end