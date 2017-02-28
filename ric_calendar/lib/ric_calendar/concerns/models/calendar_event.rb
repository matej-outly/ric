# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module CalendarEvent extend ActiveSupport::Concern
				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in
				# the module's context.
				#
				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					# belongs_to :document_folder, class_name: RicCalendar.document_folder_model.to_s
					# has_many :document_versions, class_name: RicCalendar.document_version_model.to_s, dependent: :delete_all # Delete instead of destroy is used

					# attr_accessor :attachment # Attachment plays important role in document
					#                           # creation. It is source of document's name
					#                           # (via attachment.original_filename attribute)
					attr_accessor :title
					attr_accessor :description

					before_save :save_calendar_data, on: :create

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
							:start_date,
							:start_time,
							:end_date,
							:end_time,
							:all_day,
							:calendar_event_template_id,
							:is_modified,
							:calendar_data_id,

							:title,
							:description
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
				# Calendar data
				# *************************************************************************

				def save_calendar_data
					calendar_data = RicCalendar.calendar_data_model.create(
						title: self.title,
						description: self.description,
					)

					self.calendar_data_id = calendar_data.id
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
						title: self.calendar_data.title,
						start: self.start_datetime,
						end: self.end_datetime,
						allDay: self.all_day,
					}
				end


			end

		end
	end
end