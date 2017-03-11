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
					before_action :authorize_event_read
					before_action :authorize_event_write, only: [:new, :edit, :create, :update, :update_schedule, :destroy]
					before_action :save_referrer, only: [:new, :edit]
					before_action :set_event, only: [:show, :edit, :update, :update_schedule, :destroy]
				end

				def show
				end

				def new
					@event = RicCalendar.event_model.new
					@event.start_date = Date.today
					@event.end_date = Date.today

					@event.start_time = Time.now.change(sec: 0, usec: 0)
					@event.end_time = @event.start_time + 1.hour
				end

				def edit
				end

				def create
					@event = RicCalendar.event_model.new(event_params)
					if @event.save
						redirect_url = load_referrer
						redirect_url = ric_calendar.calendars_path if redirect_url.blank?
						redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.create")
					else
						render "new"
					end
				end

				def update
					if @event.update(event_params)
						redirect_url = load_referrer
						redirect_url = ric_calendar.calendars_path if redirect_url.blank?
						redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.update")
					else
						render "new"
					end
				end

				#
				# Update via AJAX request from Fullcalendar
				#
				def update_schedule
					if @event.update(event_params)
						respond_to do |format|
							format.json { render json: true }
						end
					else
						respond_to do |format|
							format.json { render json: false }
						end
					end
				end

				def destroy
					@event.destroy
					redirect_url = request.referrer
					redirect_url = ric_calendar.calendars_path if redirect_url.blank?
					redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.destroy")
				end

			protected

				def authorize_event_read
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				def authorize_event_write
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_event
					@event = RicCalendar.event_model.find_by_id(params[:id])
					if @event.nil?
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicCalendar.event_model.model_name.i18n_key}.not_found")
					end
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def event_params
					params.require(:event).permit(RicCalendar.event_model.permitted_columns)
				end

			end
		end
	end
end