# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
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
					before_action :authorize_read
					before_action :authorize_write, only: [:new, :edit, :create, :update, :destroy]
					before_action :save_referrer, only: [:new, :edit]
					before_action :set_event, only: [:show, :edit, :update, :destroy]
					before_action :set_attributes_from_params, only: [:show, :edit, :update, :destroy]
				end

				def show
				end

				def new
					@event = RicCalendar.event_model.new

					# Date and time values
					if params.has_key?(:date)
						# Default values for date and time are in date attribute
						date_time = DateTime.parse(params[:date])
						@event.date_from = date_time
						@event.date_to = date_time

						@event.time_from = date_time
						@event.time_to = @event.time_from + 1.hour


					else
						# Default values for date and time is determined from current moment
						@event.date_from = Date.today
						@event.date_to = Date.today

						@event.time_from = Time.now.change(sec: 0, usec: 0)
						@event.time_to = @event.time_from + 1.hour
					end

					# Valid from
					@event.valid_from = @event.date_from

					# Valid to end of season if possible
					current_season = RicSeason.season_model.current if defined?(RicSeason)
					if current_season != nil
						@event.valid_to = current_season.to
					else
						@event.valid_to = @event.date_to
					end
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
						respond_to do |format|
							format.html  do
								redirect_url = load_referrer
								redirect_url = ric_calendar.calendars_path if redirect_url.blank?
								redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.update")
							end

							format.json { render json: true }
						end
					else
						respond_to do |format|
							format.html { render "new" }
							format.json { render json: @event.errors }
						end
					end
				end

				def destroy
					if !@event.is_recurring? || @event.scheduled_date_from.blank?
						# Destroy event and all its occurrences
						@event.destroy
					else
						# Destroy event only in given time
						@event.recurrence_exclude << @event.scheduled_date_from
						@event.save
					end

					# TODO: This old solution won't work, because usually we are comming from details page,
					#       which won't exist after model deletion:
					#redirect_url = request.referrer
					#redirect_url = ric_calendar.calendars_path if redirect_url.blank?

					redirect_url = ric_calendar.calendars_path
					redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.destroy")
				end

			protected

				# *************************************************************
				# Authorization
				# *************************************************************
				
				def authorize_read
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				def authorize_write
					if !can_read_and_write?
						not_authorized!
					end
				end

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_event
					@event = RicCalendar.event_model.find_by_id(params[:id])
					if @event.nil?
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicCalendar.event_model.model_name.i18n_key}.not_found")
					end
				end

				def set_attributes_from_params
					@event.scheduled_date_from = params[:scheduled_date_from] unless params[:scheduled_date_from].nil?
					@event.update_action = params[:update_action] unless params[:update_action].nil?
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