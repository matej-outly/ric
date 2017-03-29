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
				module GalleryDirectoriesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_gallery_directory, only: [:show, :edit, :update, :move_up, :move_down, :destroy]

					end

					def index
						@gallery_directories = RicGallery.gallery_directory_model.all.order(lft: :asc)
						@gallery_pictures = RicGallery.gallery_picture_model.without_directory.order(position: :asc)
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @gallery_directory.to_json }
						end
					end

					def new
						@gallery_directory = RicGallery.gallery_directory_model.new
					end

					def edit
					end

					def create
						@gallery_directory = RicGallery.gallery_directory_model.new(gallery_directory_params)
						if @gallery_directory.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.create") }
								format.json { render json: @gallery_directory.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @gallery_directory.errors }
							end
						end
					end

					def update
						if @gallery_directory.update(gallery_directory_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.update") }
								format.json { render json: @gallery_directory.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @gallery_directory.errors }
							end
						end
					end

					def move_up
						@gallery_directory.move_left
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.gallery_directory_model.model_name.i18n_key}.move") }
							format.json { render json: @gallery_directory.id }
						end
					end

					def move_down
						@gallery_directory.move_right
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.gallery_directory_model.model_name.i18n_key}.move") }
							format.json { render json: @gallery_directory.id }
						end
					end
					
					def destroy
						@gallery_directory.destroy
						respond_to do |format|
							format.html { redirect_to gallery_directories_path, notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.destroy") }
							format.json { render json: @gallery_directory.id }
						end
					end

				protected

					def set_gallery_directory
						@gallery_directory = RicGallery.gallery_directory_model.find_by_id(params[:id])
						if @gallery_directory.nil?
							redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.not_found")
						end
					end

					def gallery_directory_params
						params.require(:gallery_directory).permit(RicGallery.gallery_directory_model.permitted_columns)
					end

				end
			end
		end
	end
end
