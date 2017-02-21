# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document Versions
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

# require_dependency "controllers/ric_dms/application_controller"

module RicDms
	module Concerns
		module Controllers
			module DocumentVersionsController extend ActiveSupport::Concern

				def destroy

					document_version = RicDms.document_version_model.find(params[:id])

					if document_version
						# Save document for redirection after deletion
						document = document_version.document

						# Destroy document version, may destroy also document itself
						# if it is only document_version
						document_version.destroy

						# Redirect to document or folder, if document is also destroyed
						if !document.destroyed?
							redirect_to document
						else
							redirect_to (document.document_folder || document_folders_path)
						end

					else
						not_found
					end
				end

			end
		end
	end
end