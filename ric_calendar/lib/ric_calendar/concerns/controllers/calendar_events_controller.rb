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
			module CalendarEventsController extend ActiveSupport::Concern

				included do
					helper_method :has_calendar_id?
				end

				# *************************************************************************
				# Actions
				# *************************************************************************

				def new
					if can_read_and_write?
						@calendar_event = RicCalendar.calendar_event_model.new
						@calendar_event.start_date = Date.today
						@calendar_event.end_date = Date.today

						@calendar_event.start_time = Time.now.change(sec: 0, usec: 0)
						@calendar_event.end_time = @calendar_event.start_time + 1.hour


					else
						not_authorized!
					end
				end

				def create
					if can_read_and_write?
						@calendar_event = RicCalendar.calendar_event_model.new(calendar_event_params)
						if @calendar_event.save
							redirect_to calendar_index_url
						else
							render "new"
						end
					else
						not_authorized!
					end
				end

				# *************************************************************************
				# Methods
				# *************************************************************************

				#
				# Check, if instance has optional attribute "calendar_id"
				#
				def has_calendar_id?
					RicCalendar.calendar_event_model.column_names.include?("calendar_id")
				end

			protected

				def calendar_event_params
					params.require(:calendar_event).permit(RicCalendar.calendar_event_model.permitted_columns)
				end

			end
		end
	end
end