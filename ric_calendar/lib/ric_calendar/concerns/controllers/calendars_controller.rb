# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendars
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Controllers
			module CalendarsController extend ActiveSupport::Concern

				included do
					before_action :authorize_read
					before_action :authorize_write, only: [:new, :edit, :create, :update, :destroy]
					before_action :save_referrer, only: [:new, :edit]
					before_action :set_calendar, only: [:edit, :update, :destroy]
				end

				#
				# Show calendar as regular HTML page
				#
				def index
					@calendars = RicCalendar.calendar_model.all.order(name: :asc)
				end

				#
				# Return events in Fullcalendar format via AJAX
				#
				def events
					date_from = Date.parse(params[:start].to_s)
					date_to = Date.parse(params[:end].to_s)
					disabled_calendars = params[:disabled_calendars]
					render json: load_calendars(date_from, date_to, disabled_calendars)
				end

				#
				# Return available resources
				#
				def resources
					result = []
					available_resource_types = RicCalendar.calendar_kinds.map { |key, value| value[:resource_type] }.uniq.delete_if { |value| value.nil? || value == RicCalendar.calendar_model.to_s }
					available_resource_types.each do |resource_type|
						result += resource_type.constantize.search(params[:q]).to_a
					end
					render json: result
				end

				def new
					@calendar = RicCalendar.calendar_model.new
				end

				def edit
				end

				def create
					@calendar = RicCalendar.calendar_model.new(calendar_params)
					if @calendar.save
						redirect_url = load_referrer
						redirect_url = ric_calendar.calendars_path if redirect_url.blank?
						redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.calendar_model.model_name.i18n_key}.create")
					else
						render "new"
					end
				end

				def update
					if @calendar.update(calendar_params)
						redirect_url = load_referrer
						redirect_url = ric_calendar.calendars_path if redirect_url.blank?
						redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.calendar_model.model_name.i18n_key}.update")
					else
						render "edit"
					end
				end

				def destroy
					@calendar.destroy
					redirect_url = ric_calendar.calendars_path
					redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.calendar_model.model_name.i18n_key}.destroy")
				end

			protected

				# *************************************************************
				# Paths for override
				# *************************************************************

				def follow_event_path(calendar_kind, event, params = {})
					if calendar_kind == :simple
						return ric_calendar.event_path(event, params)
					else
						return nil
					end
				end

				def update_event_path(calendar_kind, event, params = {})
					if calendar_kind == :simple
						return ric_calendar.event_path(event, params)
					else
						return nil
					end
				end

				# *************************************************************
				# Authorization
				# *************************************************************

				def authorize_read
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				def authorize_write
					if !(can_read_and_write?)
						not_authorized!
					end
				end

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_calendar
					@calendar = RicCalendar.calendar_model.find_by_id(params[:id])
					if @calendar.nil?
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicCalendar.calendar_model.model_name.i18n_key}.not_found")
					end
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def calendar_params
					params.require(:calendar).permit(RicCalendar.calendar_model.permitted_columns)
				end

				# *************************************************************
				# Content loading
				# *************************************************************

				#
				# Read events from calendars
				#
				def load_calendars(date_from, date_to, disabled_calendars)
					fullevents = []

					#path_resolver = RugSupport::PathResolver.new(self)

					RicCalendar.calendar_model.not_disabled(disabled_calendars).each do |calendar|

						# Get calendar color and action edit method
						if !calendar.color.blank?
							color_primary = calendar.color_primary
							color_text = calendar.color_text
						end
						
						# Go through scheduled calendar events
						selected_events = calendar.select_events(current_user)
						if selected_events
							selected_events.schedule(date_from, date_to).each do |scheduled_event|

								# Create Fullcalendar event object
								fullevent = {
									id: "#{calendar.kind_options[:event_type]}<#{scheduled_event[:event].id}>[#{scheduled_event[:recurrence_id]}]",
									objectId: scheduled_event[:event].id,
									start: scheduled_event[:event].datetime_from(scheduled_event[:date_from]),
									end: scheduled_event[:event].datetime_to(scheduled_event[:date_to]),
									allDay: scheduled_event[:all_day],
									isRecurring: scheduled_event[:is_recurring],
								}

								# Update object by calendar specific attributes - colors
								if color_primary
									fullevent[:textColor] = color_text
									fullevent[:borderColor] = color_primary
									fullevent[:backgroundColor] = color_primary
								end

								# Update object by calendar specific attributes - paths
								follow_event_path = follow_event_path(calendar.kind.to_sym, scheduled_event[:event], scheduled_date_from: scheduled_event[:date_from])
								update_event_path = update_event_path(calendar.kind.to_sym, scheduled_event[:event])
								if follow_event_path
									fullevent[:url] = follow_event_path
								end
								if update_event_path && can_read_and_write? # Edit events (currently only simple non-repeating events)
									fullevent[:editable] = true
									fullevent[:editUrl] = update_event_path
								end

								# Update object by class specific attributes
								fullevent[:title] = scheduled_event[:event].event_title

								# Insert into events
								fullevents << fullevent

							end
						end
					end

					return fullevents
				end

			end
		end
	end
end