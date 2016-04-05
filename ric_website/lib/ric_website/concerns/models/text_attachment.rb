# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Text attachment
# *
# * Author: Matěj Outlý
# * Date  : 15. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module TextAttachment extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Attachments
					# *********************************************************

					#
					# File
					#
					has_attached_file :file
					validates_attachment_content_type :file, :content_type => /\A.*\Z/

					# *********************************************************
					# Kind
					# *********************************************************

					before_save do
						if self.file_content_type
							if self.file_content_type.start_with?("image/")
								self.kind = "image"
							else
								self.kind = nil
							end
						end
					end

				end

			end
		end
	end
end