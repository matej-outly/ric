# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Models
			module Document extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :document_folder, class_name: RicDms.document_folder_model.to_s
					has_many :document_versions, class_name: RicDms.document_version_model.to_s, dependent: :delete_all # Delete instead of destroy is used

					# *********************************************************
					# Version
					# *********************************************************

					after_save :create_document_version_after_save

					# *********************************************************
					# Name
					# *********************************************************

					before_validation :set_name_before_validation

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :attachment, :name, :document_folder_id
					
					# *********************************************************
					# Hooks & notifications
					# *********************************************************

					after_commit :notify_new_document, on: :create
					after_commit :notify_new_document_version, on: :update
					after_commit :notify_destroyed_document, on: :destroy

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						[
							:name,
							:description,
							:document_folder_id,
							:attachment
						]
					end

				end

				# *************************************************************
				# Attachment
				# *************************************************************

				def attachment=(new_attachment)
					@attachment = new_attachment
					@request_new_document_version = true if !new_attachment.nil?
				end

				def attachment
					if @attachment.nil? && self.current_version
						@attachment = self.current_version.attachment
					end
					return @attachment
				end

				def attachment_file_name
					if self.current_version
						return self.current_version.attachment_file_name
					else
						return nil
					end
				end

				def attachment_file_size
					if self.current_version
						return self.current_version.attachment_file_size
					else
						return nil
					end
				end

				# *************************************************************
				# Versions
				# *************************************************************

				#
				# Get the latest (current) version of document
				#
				def current_version
					if @current_version.nil?
						@current_version = document_versions.order(id: :desc).first
					end
					return @current_version
				end

				#
				# Get list of all versions of document ordered from newest to oldest
				#
				def recent_versions
					if @recent_versions.nil?
						@recent_versions = document_versions.order(id: :desc)
					end
					return @recent_versions
				end

				# *************************************************************
				# Hooks & notifications
				# *************************************************************

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

			protected

				# *************************************************************
				# Versions
				# *************************************************************

				#
				# Create document version, if requested
				#
				def create_document_version_after_save
					if @request_new_document_version == true
						self.document_versions.create(attachment: self.attachment)
						@current_version = nil
						@recent_versions = nil
					end
				end

				# *************************************************************
				# Name
				# *************************************************************

				def set_name_before_validation
					p "BEFORE VALID"
					p self.name
					p self.attachment
					if self.name.blank? && !self.attachment.nil?
						self.name = self.attachment.original_filename
						p self.name
					end
				end

			end

		end
	end
end