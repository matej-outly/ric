# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Controllers
			module FoldersController extend ActiveSupport::Concern

				included do

					before_action :set_documents_and_folders, only: [:index, :show]
					before_action :set_document_folder, only: [:edit, :update, :destroy]

				end

				# *************************************************************
				# Actions
				# *************************************************************

				def index
				end

				def show
					render "index"
				end

				def new
					@document_folder = RicDms.document_folder_model.new
					@document_folder.parent_id = params[:folder_id] if params[:folder_id]
				end

				def edit
				end

				def create
					@document_folder = RicDms.document_folder_model.new(document_folder_params)
					if @document_folder.save
						redirect_to folder_path(@document_folder), notice: t("activerecord.notices.models.ric_dms/document_folder.create")
					else
						render "new"
					end
				end

				def update
					if @document_folder.update(document_folder_params)
						redirect_to folder_path(@document_folder), notice: t("activerecord.notices.models.ric_dms/document_folder.update")
					else
						render "edit"
					end
				end

				def destroy
					@document_folder.destroy
					redirect_to (@document_folder.parent ? folder_path(@document_folder.parent) : folders_path), notice: t("activerecord.notices.models.ric_dms/document_folder.destroy")
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_document_folder
					@document_folder = RicDms.document_folder_model.find(params[:id])
					if @document_folder.nil?
						redirect_to folders_path, alert: t("activerecord.errors.models.ric_dms/document_folder.not_found")
					end
				end

				def set_documents_and_folders
					@document_folder = params[:id] ? RicDms.document_folder_model.find(params[:id]) : nil
					@document_folders = RicDms.document_folder_model.where(parent_id: params[:id]).order(name: :asc, id: :asc)
					@documents = RicDms.document_model.where(document_folder_id: params[:id]).order(name: :asc, id: :asc)
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def document_folder_params
					params.require(:document_folder).permit(RicDms.document_folder_model.permitted_columns)
				end

			end
		end
	end
end