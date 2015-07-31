# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Images
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicGallery
	module Concerns
		module Controllers
			module Admin
				module ImagesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set image before some actions
						#
						before_action :set_gallery_image, only: [:show, :edit, :update, :destroy]

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
						@gallery_image = RicGallery.gallery_image_model.new
						@gallery_image.gallery_directory_id = params[:gallery_directory_id] 
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
						@gallery_image = RicGallery.gallery_image_model.new(gallery_image_params)
						if @gallery_image.save
							respond_to do |format|
								format.html { redirect_to image_path(@gallery_image), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_image_model.model_name.i18n_key}.create") }
								format.json { render json: @gallery_image.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @gallery_image.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @gallery_image.update(gallery_image_params)
							respond_to do |format|
								format.html { redirect_to image_path(@gallery_image), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_image_model.model_name.i18n_key}.update") }
								format.json { render json: @gallery_image.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @gallery_image.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@gallery_image.destroy
						respond_to do |format|
							format.html { redirect_to directories_path, notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_image_model.model_name.i18n_key}.destroy") }
							format.json { render json: @gallery_image.id }
						end
					end

				protected

					def set_gallery_image
						@gallery_image = RicGallery.gallery_image_model.find_by_id(params[:id])
						if @gallery_image.nil?
							redirect_to images_path, alert: I18n.t("activerecord.errors.models.#{RicGallery.gallery_image_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def gallery_image_params
						params.require(:gallery_image).permit(:gallery_directory_id, :image, :title)
					end

				end
			end
		end
	end
end
