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
			module DocumentsController extend ActiveSupport::Concern

				included do

					before_action :set_root_folder
					before_action :set_document_folder
					before_action :set_document, only: [:show, :edit, :update, :destroy]

					# *********************************************************
					# Authorization
					# *********************************************************

					before_action only: [:show] do
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

				def show
				end

				def new
					@document = RicDms.document_model.new
				end

				def edit	
				end

				def create
					# Get existing or create new document and add attachment into it
					@document = RicDms.document_model.new(document_params) #find_or_new_with_attachment(document_params)
					@document.document_folder_id = @document_folder.id
					if @document.save
						respond_to do |format|
							format.html { redirect_to folder_path(@document.document_folder), notice: RicDms.document_model.human_notice_message(:create) }
							format.json { render json: @document.id }
						end
					else
						respond_to do |format|
							format.html { render "new" }
							format.json { render json: @document.errors }
						end
					end
				end

				def update
					@document.assign_attributes(document_params)
					@document.document_folder_id = @document_folder.id
					if @document.save
						respond_to do |format|
							format.html { redirect_to folder_path(@document.document_folder), notice: RicDms.document_model.human_notice_message(:update) }
							format.json { render json: @document.id }
						end
					else
						respond_to do |format|
							format.html { render "edit" }
							format.json { render json: @document.errors }
						end
					end
				end

				def destroy
					@document.destroy
					respond_to do |format|
						format.html { redirect_to folder_path(@document.document_folder), notice: RicDms.document_model.human_notice_message(:destroy) }
						format.json { render json: @document.id }
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
					@document = RicDms.document_model.find(params[:id])
					not_found if @document.nil? || @document.document_folder_id != @document_folder.id
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def document_params
					params.require(:document).permit(RicDms.document_model.permitted_columns)
				end

			end
		end
	end
end