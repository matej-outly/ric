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
						before_action :set_image, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@images = RicGallery.image_model.all.order(held_at: :desc).page(params[:page]).per(50)
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
						@image = RicGallery.image_model.new
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
						@image = RicGallery.image_model.new(image_params)
						if @image.save
							redirect_to image_path(@image), notice: I18n.t("activerecord.notices.models.#{RicGallery.image_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @image.update(image_params)
							redirect_to image_path(@image), notice: I18n.t("activerecord.notices.models.#{RicGallery.image_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@image.destroy
						redirect_to images_path, notice: I18n.t("activerecord.notices.models.#{RicGallery.image_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_image
						@image = RicGallery.image_model.find_by_id(params[:id])
						if @image.nil?
							redirect_to images_path, alert: I18n.t("activerecord.errors.models.#{RicGallery.image_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def image_params
						params.require(:image).permit(:title, :perex, :content, :held_at)
					end

				end
			end
		end
	end
end
