# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Directories
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicGallery
	module Concerns
		module Controllers
			module Admin
				module DirectoriesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set directory before some actions
						#
						before_action :set_gallery_directory, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@gallery_directories = RicGallery.gallery_directory_model.all.order(lft: :asc)
						@gallery_pictures = RicGallery.gallery_picture_model.without_directory.order(position: :asc)
					end

					#
					# Show action
					#
					def show
					end

					#
					# New action
					#
					def new
						@gallery_directory = RicGallery.gallery_directory_model.new
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Create action
					#
					def create
						@gallery_directory = RicGallery.gallery_directory_model.new(gallery_directory_params)
						if @gallery_directory.save
							respond_to do |format|
								format.html { redirect_to directory_path(@gallery_directory), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.create") }
								format.json { render json: @gallery_directory.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @gallery_directory.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @gallery_directory.update(gallery_directory_params)
							respond_to do |format|
								format.html { redirect_to directory_path(@gallery_directory), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.update") }
								format.json { render json: @gallery_directory.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @gallery_directory.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@gallery_directory.destroy
						respond_to do |format|
							format.html { redirect_to directories_path, notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.destroy") }
							format.json { render json: @gallery_directory.id }
						end
					end

				protected

					def set_gallery_directory
						@gallery_directory = RicGallery.gallery_directory_model.find_by_id(params[:id])
						if @gallery_directory.nil?
							redirect_to directories_path, alert: I18n.t("activerecord.errors.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def gallery_directory_params
						params.require(:gallery_directory).permit(:name, :parent_id, :description, :picture)
					end

				end
			end
		end
	end
end
