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
			module CalendarsController extend ActiveSupport::Concern

				included do
					before_action :authorize_calendar_read
					before_action :authorize_calendar_write, only: [:new, :edit, :create, :update, :destroy]
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

					# Calendar events
					fullevents = []

					# Add events from calendars
					fullevents += load_calendars(date_from, date_to)

					# Add aditional events
					fullevents += load_events(date_from, date_to)

					# Return JSON response
					render json: fullevents
				end

				#
				# Resurn available resources
				#
				def resources
					result = []
					available_resource_types = RicCalendar.calendar_model.config(:kinds).map { |key, value| value[:resource_type] }.uniq.delete_if { |value| value == RicCalendar.calendar_model.to_s }
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
					redirect_url = request.referrer
					redirect_url = ric_calendar.calendars_path if redirect_url.blank?
					redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicCalendar.calendar_model.model_name.i18n_key}.destroy")
				end

			protected

				def authorize_calendar_read
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				def authorize_calendar_write
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_calendar
					@calendar = RicCalendar.calendar_model.find_by_id(params[:id])
					if @calendar.nil?
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicCalendar.calendar_model.model_name.i18n_key}.not_found")
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
				# Inject custom events into calendar and return list of fullcalendar objects
				#
				# To be overriden in application
				#
				def load_events(date_from, date_to)
					[]
				end

				#
				# Read events from calendars
				#
				def load_calendars(date_from, date_to)
					fullevents = []

					path_resolver = RugSupport::PathResolver.new(self)

					RicCalendar.calendar_model.all.each do |calendar|

						# Get calendar color and action edit method
						if !calendar.color.blank?
							color_primary = calendar.color_primary
							color_text = calendar.color_text
						end
						event_show_path = calendar.kind_options[:event_show_path]
						event_update_path = calendar.kind_options[:event_update_path]

						# Go through scheduled calendar events
						calendar.resource_events.schedule(date_from, date_to).each do |scheduled_event|

							# Create Fullcalendar event object
							fullevent = {
								id: "#{calendar.kind_options[:event_type]}<#{scheduled_event[:event].id}>",
								objectId: scheduled_event[:event].id,
								start: scheduled_event[:event].datetime_from(scheduled_event[:date_from]),
								end: scheduled_event[:event].datetime_to(scheduled_event[:date_to]),
								allDay: scheduled_event[:all_day],
								isRecurring: scheduled_event[:is_recurring],
							}

							# Update object by calendar specific attributes
							if color_primary
								# Color events
								fullevent[:textColor] = color_text
								fullevent[:borderColor] = color_primary
								fullevent[:backgroundColor] = color_primary
							end
							if event_show_path
								fullevent[:url] = path_resolver.resolve(event_show_path, scheduled_event[:event])
							end
							if event_update_path && !scheduled_event[:is_recurring]
								# Edit events (currently only simple non-repeating events)
								fullevent[:editable] = true
								fullevent[:editUrl] = path_resolver.resolve(event_update_path, scheduled_event[:event])
							end

							# Update object by class specific attributes
							scheduled_event[:event].to_fullcalendar(fullevent)

							# Insert into events
							fullevents << fullevent

						end
					end

					return fullevents
				end

			end
		end
	end
end