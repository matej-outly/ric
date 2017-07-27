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

					before_action :set_document_folder
					before_action :set_document, only: [:show, :edit, :update, :destroy]

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
							format.html { redirect_to folder_path(@document.document_folder), notice: t("activerecord.notices.models.ric_dms/document.create") }
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
							format.html { redirect_to folder_path(@document.document_folder), notice: t("activerecord.notices.models.ric_dms/document.update") }
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
						format.html { redirect_to folder_path(@document.document_folder), notice: t("activerecord.notices.models.ric_dms/document.destroy") }
						format.json { render json: @document.id }
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
					@document = RicDms.document_model.find(params[:id])
					if @document.nil? || @document.document_folder_id != @document_folder.id
						redirect_to folders_path, alert: t("activerecord.errors.models.ric_dms/document.not_found")
					end
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