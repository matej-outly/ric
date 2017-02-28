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

						# Add calendar events
						fullcalendar_events = []
						RicCalendar.calendar_event_model.schedule(start_date, end_date).each do |calendar_event|
							fullcalendar_event = calendar_event.to_fullcalendar

							fullcalendar_event[:editable] = true
							fullcalendar_event[:editUrl] = calendar_event_path(calendar_event.id)

							fullcalendar_events << fullcalendar_event
						end

						# Add aditional events
						fullcalendar_events += load_events(start_date, end_date)

						render json: fullcalendar_events
					else
						not_authorized!
					end
				end


				# *************************************************************************
				# Overloads
				# *************************************************************************

				#
				# Inject custom events into calendar and return list of fullcalendar objects
				#
				def load_events(start_date, end_date)
					[]
				end

			end
		end
	end
end