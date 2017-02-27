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

					# Directory listing
					# before_action :set_files_and_folders, only: [:index, :show]

				end

				# *************************************************************************
				# Actions
				# *************************************************************************

				def new
					if can_read_and_write?
						@calendar_event = RicCalendar.calendar_event_model.new
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

				def update
					if can_read_and_write?
						@calendar_event = RicCalendar.calendar_event_model.find(params[:id])

						if @calendar_event.update(calendar_event_params)
							respond_to do |format|
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.json { render json: false }
							end
						end
					else
						not_authorized!
					end
				end

			protected

				def calendar_event_params
					params.require(:calendar_event).permit(RicCalendar.calendar_event_model.permitted_columns)
				end


			end
		end
	end
end