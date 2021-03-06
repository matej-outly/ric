# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Attachment
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	module Concerns
		module Models
			module Attachment extend ActiveSupport::Concern

				included do
				
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************
					
					#validates_presence_of :node_id

					# *********************************************************
					# File
					# *********************************************************

					has_attached_file :file
					validates_attachment_content_type :file, :content_type => /\A.*\Z/

					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, [:image, :file]
					before_save :detect_kind

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					def permitted_columns
						[
							:file,
						]
					end

					# *********************************************************
					# Claim
					# *********************************************************

					#
					# Claim attachments without subject by session ID
					#
					def claim(subject, session_id)
						return false if session_id.blank?
						self.transaction do 
							self.where(subject_id: nil, session_id: session_id).each do |claimed_attachment|
								claimed_attachment.session_id = nil
								claimed_attachment.subject = subject
								claimed_attachment.save
							end
						end
						return true
					end

				end
				
				# *************************************************************
				# Kind
				# *************************************************************

				def detect_kind
					if self.file_content_type
						if self.file_content_type.start_with?("image/")
							self.kind = "image"
						else
							self.kind = "file"
						end
					else
						self.kind = nil
					end
				end

				# *************************************************************
				# Duplicate
				# *************************************************************

				def duplicate(new_subject = self.subject)
					
					# Base duplication
					new_record = self.class.new(
						subject: new_subject,
						kind: self.kind,
					) # Dup cannot be used because of attachment
					
					# File
					new_record.file = self.file if self.file.exists?
					
					# Save
					new_record.save

					return new_record
				end

				# *************************************************************
				# URL (useful even if not sluggified)
				# *************************************************************

				def url_original
					if @url_original.nil?
						@url_original = self._url_original
					end
					return @url_original
				end

			protected

				def _url_original
					"/attachments/#{self.id}"
				end

			end
		end
	end
end