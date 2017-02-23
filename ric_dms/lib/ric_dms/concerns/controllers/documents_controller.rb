# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Controllers
			module DocumentsController extend ActiveSupport::Concern

				# *************************************************************************
				# Actions
				# *************************************************************************

				def show
					if can_read? || can_read_and_write?
						@document = RicDms.document_model.find(params[:id])
					else
						not_authorized!
					end
				end

				def new
					if can_read_and_write?
						@document = RicDms.document_model.new
					else
						not_authorized!
					end
				end

				def create
					if can_read_and_write?
						# Get existing or create new document and add attachment into it
						@document = RicDms.document_model.find_or_new_with_attachment(document_params)
						if @document.save
							redirect_to (@document.document_folder || document_folders_url)
						else
							render "new"
						end
					else
						not_authorized!
					end

				end

				def destroy
					if can_read_and_write?
						document = RicDms.document_model.find(params[:id])
						document.destroy
						redirect_to (document.document_folder || document_folders_url)
					else
						not_authorized!
					end
				end


			protected

				def document_params
					params.require(:document).permit(RicDms.document_model.permitted_columns)
				end

			end
		end
	end
end