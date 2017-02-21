# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document version model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Models
			module DocumentVersion extend ActiveSupport::Concern

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					belongs_to :document


					# *************************************************************************
					# File
					# *************************************************************************

					has_attached_file :attachment
					do_not_validate_attachment_file_type :attachment

					# *************************************************************************
					# Validators
					# *************************************************************************

					validates_presence_of :attachment

					# *************************************************************************
					# Destroy orphaned document
					# *************************************************************************
					around_destroy :destroy_orphaned_document

				end

				module ClassMethods

					def destroy_orphaned_document
						# Get document
						document = self.document

						# Delete document version
						yield

						# Delete orphaned document, which has no document versions
						if document.document_versions.count == 0
							document.destroy
						end
					end

				end

			end

		end
	end
end