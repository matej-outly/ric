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

					before_action :set_root_folder
					before_action :set_documents_and_folders, only: [:index, :show]
					before_action :set_document_folder, only: [:edit, :update, :destroy]

					# *********************************************************
					# Authorization
					# *********************************************************

					before_action only: [:index, :show] do
						not_authorized if !can_load?
					end

					before_action only: [:new, :create] do
						not_authorized if !can_create?
					end

					before_action only: [:edit, :update] do
						not_authorized if !can_update?
					end

					before_action only: [:destroy] do
						not_authorized if !can_destroy?
					end

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
						redirect_to folder_path(@document_folder), notice: RicDms.document_folder_model.human_notice_message(:create)
					else
						render "new"
					end
				end

				def update
					if @document_folder.update(document_folder_params)
						redirect_to folder_path(@document_folder), notice: RicDms.document_folder_model.human_notice_message(:update)
					else
						render "edit"
					end
				end

				def destroy
					@document_folder.destroy
					redirect_to (@document_folder.parent ? folder_path(@document_folder.parent) : folders_path), notice: RicDms.document_folder_model.human_notice_message(:destroy)
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
					@document_folder = RicDms.document_folder_model.find_by_id(params[:id])
					not_found if @document_folder.nil? || !RicDms.document_folder_model.is_descendant?(@document_folder, @root_folder)
				end

				def set_documents_and_folders

					# Set working document folder
					@document_folder = params[:id] ? RicDms.document_folder_model.find_by_id(params[:id]) : nil
					@document_folder = @root_folder if @document_folder.nil? # Enforce root folder if folder not correctly defined in params
					
					# Check
					not_found if !RicDms.document_folder_model.is_descendant?(@document_folder, @root_folder)

					# Set sub-folders
					@document_folders = RicDms.document_folder_model.where(parent_id: @document_folder ? @document_folder.id : nil).order(name: :asc, id: :asc)
					
					# Set sub-documents
					@documents = RicDms.document_model.where(document_folder_id: @document_folder ? @document_folder.id : nil).order(name: :asc, id: :asc)

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