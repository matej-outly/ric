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

module RicDms
	module Concerns
		module Models
			module Document extend ActiveSupport::Concern

				# *************************************************************************
				# Structure
				# *************************************************************************

				belongs_to :document_folder
				has_many :document_versions, dependent: :delete_all # Delete instead of destroy is used

				attr_accessor :attachment # Attachment plays important role in document
				                          # creation. It is source of document's name
				                          # (via attachment.original_filename attribute)


				# *************************************************************************
				# Validators
				# *************************************************************************

				validates_presence_of :attachment
				validates_presence_of :name
				validate :attachment_belongs_to_this_document

				def attachment_belongs_to_this_document
					# Attachment must have same name as current document's name is,
					# otherwise it should be new document
					if self.name.present? && self.attachment.present? && self.name != self.attachment.original_filename
						errors.add(:attachment, "attachment does't belong to this document")
					end
				end


				# *************************************************************************
				# Columns
				# *************************************************************************

				#
				# Get all columns permitted for editation
				#
				def self.permitted_columns
					[
						:name,
						:document_folder_id,
						:attachment
					]
				end


				# *************************************************************************
				# Methods
				# *************************************************************************

				#
				# Get the latest (current) version of document
				#
				def current_version
					document_versions.order(id: :desc).first
				end

				#
				# Get list of all versions of document ordered from newest to oldest
				#
				def recent_versions
					document_versions.order(id: :desc)
				end


				# *************************************************************************
				# Hooks & notifications
				# *************************************************************************

				after_commit :notify_new_document, on: :create
				after_commit :notify_new_document_version, on: :update
				after_commit :notify_destroyed_document, on: :destroy

				def notify_new_document
					RicNotification.notify([:document_created, self], users) if defined?(RicNotification)
				end

				def notify_new_document_version
					if self.attachment
						RicNotification.notify([:document_updated, self], users) if defined?(RicNotification)
					end
				end

				def notify_destroyed_document
					RicNotification.notify([:document_destroyed, self], users) if defined?(RicNotification)
				end


				# *************************************************************************
				# Save attachment (as document version)
				# *************************************************************************

				#
				# Get new document with attachment
				#
				def self.find_or_new_with_attachment(params)
					# Get attachment
					attachment = params[:attachment]
					document_folder_id = !params[:document_folder_id].blank? ? params[:document_folder_id] : nil

					if attachment
						# Try to find existing document by filename
						# TODO: Document names case sensitivity is now up to db engine
						document = Document.find_by(name: attachment.original_filename, document_folder_id: document_folder_id)

						if document
							# Get existing document object and add attachment into it
							document.attachment = attachment

						else
							# Create new document with attachment and with name generated
							# from attachment filename
							document = Document.new(params.merge(name: attachment.original_filename))
						end

					else
						# No attachment means new document with other params we have
						document = Document.new(params)
					end

					return document
				end

				# Create document version, if attachment is available
				after_save do
					if self.attachment
						DocumentVersion.create(
							document_id: self.id,
							attachment: self.attachment,
						)
					end
				end

			end
		end
	end
end