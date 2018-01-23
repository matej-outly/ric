# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document Versions
# *
# * Author: Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Controllers
			module VersionsController extend ActiveSupport::Concern

				included do

					before_action :set_root_folder
					before_action :set_document_folder
					before_action :set_document
					before_action :set_document_version, only: [:destroy]

					# *********************************************************
					# Authorization
					# *********************************************************

					before_action only: [:destroy] do
						not_authorized if !can_destroy?
					end

				end

				def destroy
					
					# Destroy document version, may destroy also document itself
					# if it is only document_version
					@document_version.destroy

					# Redirect to document or folder, if document is also destroyed
					flash[:notice] = RicDms.document_version_model.human_notice_message(:destroy)
					if !@document.destroyed?
						redirect_to folder_document_path(@document_folder, @document)
					else
						redirect_to folder_path(@document_folder)
					end

				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_root_folder
					@root_folder = root_folder
					not_found if @root_folder === :none
					@root_folder = nil if @root_folder === :all
				end

				def set_document_folder
					@document_folder = RicDms.document_folder_model.find(params[:folder_id])
					not_found if @document_folder.nil? || !RicDms.document_folder_model.is_descendant?(@document_folder, @root_folder)
				end

				def set_document
					@document = RicDms.document_model.find(params[:document_id])
					not_found if @document.nil? || @document.document_folder_id != @document_folder.id
				end

				def set_document_version
					@document_version = RicDms.document_version_model.find(params[:id])
					not_found if @document_version.nil? || @document_version.document_id != @document.id
				end

			end
		end
	end
end