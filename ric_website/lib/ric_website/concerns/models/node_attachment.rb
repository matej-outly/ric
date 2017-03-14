# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node attachment
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module NodeAttachment extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :node, class_name: RicWebsite.node_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :node_id

					# *********************************************************
					# Attachment
					# *********************************************************

					has_attached_file :attachment
					validates_attachment_content_type :attachment, :content_type => /\A.*\Z/

					# *********************************************************
					# Kind
					# *********************************************************

					before_save :analyze_kind

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:node_id,
							:attachment,
						]
					end

				end

				def attachment_url
					if self.attachment.present?
						return self.attachment.url
					else
						return nil
					end
				end

				# *************************************************************
				# Kind
				# *************************************************************

				def analyze_kind
					if self.attachment_content_type
						if self.attachment_content_type.start_with?("image/")
							self.kind = "image"
						else
							self.kind = nil
						end
					end
					return true
				end

			end
		end
	end
end