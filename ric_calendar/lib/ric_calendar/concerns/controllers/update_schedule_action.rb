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
			module UpdateScheduleAction extend ActiveSupport::Concern

				#
				# Update via AJAX request from Fullcalendar
				#
				def update_schedule
					if can_read_and_write?
						@event = RicCalendar.event_model.find(params[:id])

						if @event.update(event_params)
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

			end
		end
	end
end