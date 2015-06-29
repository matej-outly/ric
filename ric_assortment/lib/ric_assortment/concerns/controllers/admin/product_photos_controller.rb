# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product photos
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductPhotosController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product_photo, only: [:show, :edit, :update, :destroy]

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
						@product_photo = RicAssortment.product_photo_model.new
						if params[:product_id]
							@product_photo.product_id = params[:product_id] 
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.specimen_photo.attributes.product_id.blank")
						end
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
						@product_photo = RicAssortment.product_photo_model.new(product_photo_params)
						if @product_photo.save
							redirect_to product_photo_path(@product_photo), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_photo_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product_photo.update(product_photo_params)
							redirect_to product_photo_path(@product_photo), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_photo_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_photo.destroy
						redirect_to product_path(@product_photo.product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_photo_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_photo
						@product_photo = RicAssortment.product_photo_model.find_by_id(params[:id])
						if @product_photo.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_photo_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_photo_params
						params.require(:product_photo).permit(:product_id, :title, :image)
					end

				end
			end
		end
	end
end
