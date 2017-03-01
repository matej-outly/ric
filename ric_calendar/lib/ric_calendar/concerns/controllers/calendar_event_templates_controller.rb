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
			module CalendarEventTemplatesController extend ActiveSupport::Concern

				# *************************************************************************
				# Actions
				# *************************************************************************

				def new
					if can_read_and_write?
						@calendar_event_template = RicCalendar.calendar_event_template_model.new
						@calendar_event_template.build_calendar_data
					else
						not_authorized!
					end
				end

				def create
					if can_read_and_write?
						@calendar_event_template = RicCalendar.calendar_event_template_model.new(calendar_event_template_params)
						if @calendar_event_template.save
							redirect_to calendar_index_url
						else
							render "new"
						end
					else
						not_authorized!
					end
				end

				#
				# Update via AJAX request from Fullcalendar
				#
				def update
					if can_read_and_write?
						@calendar_event_template = RicCalendar.calendar_event_template_model.find(params[:id])

						if @calendar_event_template.update(calendar_event_template_params)
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

				def calendar_event_template_params
					params.require(:calendar_event_template).permit(
						RicCalendar.calendar_event_template_model.permitted_columns,
						"#{RicCalendar.calendar_data_model.model_name.param_key}_attributes" => RicCalendar.calendar_data_model.permitted_columns,
					)
				end


			end
		end
	end
end