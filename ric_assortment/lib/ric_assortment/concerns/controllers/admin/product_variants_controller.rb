# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product variants
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductVariantsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product variant before some actions
						#
						before_action :set_product_variant, only: [:show, :edit, :update, :destroy]

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
						@product_variant = RicAssortment.product_variant_model.new
						if params[:product_id]
							@product_variant.product_id = params[:product_id] 
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_variant_model.model_name.i18n_key}.attributes.product_id.blank")
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
						@product_variant = RicAssortment.product_variant_model.new(product_variant_params)
						if @product_variant.save
							redirect_to product_variant_path(@product_variant), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_variant_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product_variant.update(product_variant_params)
							redirect_to product_variant_path(@product_variant), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_variant_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_variant.destroy
						redirect_to product_path(@product_variant.product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_variant_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_variant
						@product_variant = RicAssortment.product_variant_model.find_by_id(params[:id])
						if @product_variant.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_variant_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_variant_params
						result = params.require(:product_variant).permit(:product_id, :name, :required, :operator, :sub_product_ids)
						result[:sub_product_ids] = result[:sub_product_ids].split(",") if !result[:sub_product_ids].blank?
						return result
					end

				end
			end
		end
	end
end
