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

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in
				# the module's context.
				#
				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					belongs_to :document_folder, class_name: RicDms.document_folder_model.to_s
					has_many :document_versions, class_name: RicDms.document_version_model.to_s, dependent: :delete_all # Delete instead of destroy is used

					attr_accessor :attachment # Attachment plays important role in document
					                          # creation. It is source of document's name
					                          # (via attachment.original_filename attribute)

					after_save :save_document_version

					# *************************************************************************
					# Validators
					# *************************************************************************

					validates_presence_of :attachment
					validates_presence_of :name
					validate :attachment_belongs_to_this_document

					# *************************************************************************
					# Hooks & notifications
					# *************************************************************************

					after_commit :notify_new_document, on: :create
					after_commit :notify_new_document_version, on: :update
					after_commit :notify_destroyed_document, on: :destroy

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

					# *************************************************************************
					# Save attachment (as document version)
					# *************************************************************************

					#
					# Get new document with attachment
					#
					def find_or_new_with_attachment(params)
						# Get attachment
						attachment = params[:attachment]
						document_folder_id = !params[:document_folder_id].blank? ? params[:document_folder_id] : nil

						if attachment
							# Try to find existing document by filename
							# TODO: Document names case sensitivity is now up to db engine
							document = RicDms.document_model.find_by(name: attachment.original_filename, document_folder_id: document_folder_id)

							if document
								# Get existing document object and add attachment into it
								document.attachment = attachment

							else
								# Create new document with attachment and with name generated
								# from attachment filename
								document = RicDms.document_model.new(params.merge(name: attachment.original_filename))
							end

						else
							# No attachment means new document with other params we have
							document = RicDms.document_model.new(params)
						end

						return document
					end

				end




				# *************************************************************************
				# Validators
				# *************************************************************************

				def attachment_belongs_to_this_document
					# Attachment must have same name as current document's name is,
					# otherwise it should be new document
					if self.name.present? && self.attachment.present? && self.name != self.attachment.original_filename
						errors.add(:attachment, "attachment does't belong to this document")
					end
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


			protected


				# Create document version, if attachment is available
				def save_document_version
					if self.attachment
						RicDms.document_version_model.create(
							document_id: self.id,
							attachment: self.attachment,
						)
					end
				end

			end

		end
	end
end