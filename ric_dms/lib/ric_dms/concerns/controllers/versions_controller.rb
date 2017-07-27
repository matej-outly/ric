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

					before_action :set_document_folder
					before_action :set_document
					before_action :set_document_version

				end

				def destroy
					
					# Destroy document version, may destroy also document itself
					# if it is only document_version
					@document_version.destroy

					# Redirect to document or folder, if document is also destroyed
					flash[:notice] = t("activerecord.notices.models.ric_dms/document_version.destroy")
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

				def set_document_folder
					@document_folder = RicDms.document_folder_model.find(params[:folder_id])
					if @document_folder.nil?
						redirect_to folders_path, alert: t("activerecord.errors.models.ric_dms/document_folder.not_found")
					end
				end

				def set_document
					@document = RicDms.document_model.find(params[:document_id])
					if @document.nil? || @document.document_folder_id != @document_folder.id
						redirect_to folders_path, alert: t("activerecord.errors.models.ric_dms/document.not_found")
					end
				end

				def set_document_version
					@document_version = RicDms.document_version_model.find(params[:id])
					if @document_version.nil? || @document_version.document_id != @document.id
						redirect_to folders_path, alert: t("activerecord.errors.models.ric_dms/document_version.not_found")
					end
				end

			end
		end
	end
end