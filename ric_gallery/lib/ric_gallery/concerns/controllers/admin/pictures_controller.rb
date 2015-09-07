# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Pictures
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicGallery
	module Concerns
		module Controllers
			module Admin
				module PicturesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set picture before some actions
						#
						before_action :set_gallery_picture, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@gallery_pictures = RicGallery.gallery_picture_model.all.order(position: :asc)
					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @gallery_picture.to_json }
						end
					end

					#
					# New action
					#
					def new
						@gallery_picture = RicGallery.gallery_picture_model.new
						@gallery_picture.gallery_directory_id = params[:gallery_directory_id] 
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
						@gallery_picture = RicGallery.gallery_picture_model.new(gallery_picture_params)
						if @gallery_picture.save
							respond_to do |format|
								format.html { redirect_to picture_path(@gallery_picture), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_picture_model.model_name.i18n_key}.create") }
								format.json { render json: @gallery_picture.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @gallery_picture.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @gallery_picture.update(gallery_picture_params)
							respond_to do |format|
								format.html { redirect_to picture_path(@gallery_picture), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_picture_model.model_name.i18n_key}.update") }
								format.json { render json: @gallery_picture.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @gallery_picture.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@gallery_picture.destroy
						respond_to do |format|
							format.html { redirect_to (@gallery_picture.gallery_directory_id ? directory_path(@gallery_picture.gallery_directory_id) : directories_path), notice: I18n.t("activerecord.notices.models.#{RicGallery.gallery_picture_model.model_name.i18n_key}.destroy") }
							format.json { render json: @gallery_picture.id }
						end
					end

				protected

					def set_gallery_picture
						@gallery_picture = RicGallery.gallery_picture_model.find_by_id(params[:id])
						if @gallery_picture.nil?
							redirect_to pictures_path, alert: I18n.t("activerecord.errors.models.#{RicGallery.gallery_picture_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def gallery_picture_params
						params.require(:gallery_picture).permit(:gallery_directory_id, :picture, :title)
					end

				end
			end
		end
	end
end
