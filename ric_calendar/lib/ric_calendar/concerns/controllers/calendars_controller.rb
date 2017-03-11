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
					@calendars = RicCalendar.calendar_model.all.order(title: :asc)
				end

				#
				# Return events in Fullcalendar format via AJAX
				#
				def events
					start_date = Date.parse(params[:start].to_s)
					end_date = Date.parse(params[:end].to_s)

					# Calendar events
					fullevents = []

					# Add events from calendars
					fullevents += load_calendars(start_date, end_date)

					# Add aditional events
					fullevents += load_events(start_date, end_date)

					# Return JSON response
					render json: fullevents
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
				def load_events(start_date, end_date)
					[]
				end

				#
				# Read events from calendars
				#
				def load_calendars(start_date, end_date)
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
						calendar.resource_events.schedule(start_date, end_date).each do |scheduled_event|

							# Create Fullcalendar event object
							fullevent = {
								id: "#{calendar.kind_options[:event_type]}<#{scheduled_event[:event].id}>",
								objectId: scheduled_event[:event].id,
								start: scheduled_event[:event].start_datetime(scheduled_event[:start_date]),
								end: scheduled_event[:event].end_datetime(scheduled_event[:end_date]),
								allDay: scheduled_event[:all_day],
							}

							# Update object by calendar specific attributes
							if color_primary
								# Color events
								fullevent[:color] = color_text
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