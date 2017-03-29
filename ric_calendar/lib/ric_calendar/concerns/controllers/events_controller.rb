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
					before_action :set_scheduled_date_from, only: [:show, :edit, :update, :update_schedule, :destroy]
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

					# Valid to end of school year
					current_season = RicSeason::Season.current
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
					if @event.update(event_params) #_update
						redirect_url = load_referrer
						redirect_url = ric_calendar.calendars_path if redirect_url.blank?
						redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.update")
					else
						render "new"
					end

					# _update.each do |affected_event|
					# 	unless affected_event.save
					# 		if affected_event != @event
					# 			affected_event.errors.each do |attribute, error|
					# 				@event.errors.add attribute, error
					# 			end
					# 		end
					# 	end
					# end

					# # byebug

					# if @event.errors.empty?
					# 	redirect_url = load_referrer
					# 	redirect_url = ric_calendar.calendars_path if redirect_url.blank?
					# 	redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.event_model.model_name.i18n_key}.update")
					# else
					# 	render "new"
					# end
				end

				#
				# Update via AJAX request from Fullcalendar
				#
				def update_schedule
					if !@event.is_recurring?
						# Editing simple events is easy... just pass new date and time
						if @event.update(event_params)
							respond_to do |format|
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.json { render json: @event.errors }
							end
						end

					else
						# Recurring event
						event_data = event_params

						# Extract occurrence
						extracted_event = @event.extract(@event.scheduled_date_from)

						# Set new date and time
						extracted_event.date_from = event_data[:date_from]
						extracted_event.date_to = event_data[:date_to]
						extracted_event.time_from = event_data[:time_from]
						extracted_event.time_to = event_data[:time_to]
						extracted_event.all_day = event_data[:all_day]

						# Save changes
						if @event.save && extracted_event.save
							respond_to do |format|
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.json { render json: event.errors }
							end
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

				def set_scheduled_date_from
					@event.scheduled_date_from = params[:scheduled_date_from] unless params[:scheduled_date_from].nil?
					@event.update_action = params[:update_action] unless params[:update_action].nil?
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def event_params
					params.require(:event).permit(RicCalendar.event_model.permitted_columns)
				end

				# *************************************************************
				# Update event
				# *************************************************************

				def _update
					if params[:update_action] == "only_this"
						recurrent_row = @event.extract_from_recurrent(@event.scheduled_date_from)

					elsif params[:update_action] == "all_future"

					else
						return @event.update(event_params)
					end
				end

				def _update2
					event_data = event_params

					if @event.is_recurring? && event_data[:recurrence_rule] != "null" && params[:update_action] != "all"
						if params[:update_action] == "only_this"
							# Extract event and update its fields
							extracted_event = @event.extract(@event.scheduled_date_from)
							extracted_event.assign_attributes(event_data)

							return [@event, extracted_event]

						elsif params[:update_action] == "all_future"
							# Split event and update only the future occurrences
							new_event = @event.split(@event.scheduled_date_from)
							new_event.assign_attributes(event_data)
							new_event.valid_from = split_date

							return [@event, new_event]

						else
							raise "Unknown event update action, possibles are: only_this, all_future"
						end

						# && data[:update_action] == "future" && @event.valid_to >= today
						# # Split recurring event and make changes only on new instance
						# new_event = @event.dup

						# # Set old event validity
						# @event.valid_to = yesterday

						# # Update event attributes

						# new_event.valid_from = today


					else
						# Regular update
						@event.assign_attributes(event_data)
						return [ @event ]
					end
				end


			end
		end
	end
end