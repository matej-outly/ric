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

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in
				# the module's context.
				#
				included do
				end

				def show
					@document = RicDms.document_model.find(params[:id])
				end

				def new
					@document = RicDms.document_model.new
				end

				def create
					# Get existing or create new document and add attachment into it
					@document = RicDms.document_model.find_or_new_with_attachment(document_params)
					if @document.save
						redirect_to @document
					else
						render "new"
					end
				end

				def destroy
					document = RicDms.document_model.find(params[:id])
					document.destroy
					redirect_to (document.document_folder || document_folders_url)
				end


			protected

				def document_params
					params.require(:document).permit(RicDms.document_model.permitted_columns)
				end

			end
		end
	end
end