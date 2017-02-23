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

					# after_save :save_document_version

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
							:name,
							:document_folder_id,
							:attachment
						]
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

			end

		end
	end
end