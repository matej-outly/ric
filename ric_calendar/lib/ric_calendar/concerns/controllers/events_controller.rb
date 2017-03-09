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
			module EventsController extend ActiveSupport::Concern

				included do
					helper_method :has_calendar_id?
				end

				# *************************************************************************
				# Actions
				# *************************************************************************

				def show
					if can_read?
						@event = RicCalendar.event_model.find(params[:id])
					else
						not_authorized!
					end
				end

				def new
					if can_read_and_write?
						@event = RicCalendar.event_model.new
						@event.start_date = Date.today
						@event.end_date = Date.today

						@event.start_time = Time.now.change(sec: 0, usec: 0)
						@event.end_time = @event.start_time + 1.hour


					else
						not_authorized!
					end
				end

				def create
					if can_read_and_write?
						@event = RicCalendar.event_model.new(event_params)
						if @event.save
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
					RicCalendar.event_model.column_names.include?("calendar_id")
				end

			protected

				def event_params
					params.require(:event).permit(RicCalendar.event_model.permitted_columns)
				end

			end
		end
	end
end