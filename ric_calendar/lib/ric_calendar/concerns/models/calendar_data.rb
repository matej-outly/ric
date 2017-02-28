# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar Data model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module CalendarData extend ActiveSupport::Concern

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					#has_many :calendar_, class_name: RicCalendar.calendar_data_model.to_s
					#has_many :calendar_event_templates, class_name: RicCalendar.calendar_event_template_model.to_s

					# *************************************************************************
					# Validators
					# *************************************************************************

					# validates_presence_of :attachment
					# validates_presence_of :name
					# validate :attachment_belongs_to_this_document

					# *************************************************************************
					# Hooks & notifications
					# *************************************************************************

					# after_commit :notify_new_document, on: :create
					# after_commit :notify_new_document_version, on: :update
					# after_commit :notify_destroyed_document, on: :destroy

				end

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:title,
							:description,
						]
					end

					# *************************************************************************
					# Queries
					# *************************************************************************

					#
					# Return all events between given dates
					#
					def schedule(start_date, end_date)
						where("start_date >= ? AND end_date <= ?", start_date, end_date)
					end

				end

				# *************************************************************************
				# Shotcuts
				# *************************************************************************

				def start_datetime
					if self.start_time
						self.start_date.to_datetime + self.start_time.seconds_since_midnight.seconds
					else
						self.start_date.to_datetime
					end
				end

				def end_datetime
					if self.end_time
						self.end_date.to_datetime + self.end_time.seconds_since_midnight.seconds
					else
						self.end_date.to_datetime
					end
				end


				# *************************************************************************
				# Hooks & notifications
				# *************************************************************************

				def notify_new_document
					# RicNotification.notify([:document_created, self], users) if defined?(RicNotification)
				end

				def notify_new_document_version
					if self.attachment
						# RicNotification.notify([:document_updated, self], users) if defined?(RicNotification)
					end
				end

				def notify_destroyed_document
					# RicNotification.notify([:document_destroyed, self], users) if defined?(RicNotification)
				end


				# *************************************************************************
				# Conversions
				# *************************************************************************

				def to_fullcalendar
					{
						id: "RicCalendar::CalendarEvent<#{self.id}>",
						objectId: self.id,
						title: self.title,
						start: self.start_datetime,
						end: self.end_datetime,
						allDay: self.all_day,
					}
				end


			end

		end
	end
end