# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product category relations
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductCategoryRelationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do

						#
						# Set product before some actions
						#
						before_action :set_product, only: [:edit, :update, :destroy]

						#
						# Set product category before some actions
						#
						before_action :set_product_category, only: [:destroy]

					end

					#
					# New action
					#
					def edit
						@product_categories = RicAssortment.product_category_model.all.order(lft: :asc)
					end

					#
					# Create action
					#
					def update
						param_product_categories = product_params[:product_categories]
						@product.product_category_ids = ((!param_product_categories.nil? && param_product_categories.is_a?(Hash)) ? param_product_categories.keys : [])
						redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.category_bind")
					end

					#
					# Destroy action
					#
					def destroy
						@product.product_categories.delete(@product_category)
						redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.category_unbind")
					end

				protected

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:id])
						if @product.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product_category
						@product_category = RicAssortment.product_category_model.find_by_id(params[:product_category_id])
						if @product_category.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_category_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_params
						if params[:product]
							params[:product].tap do |white_listed|
								white_listed[:product_categories] = params[:product][:product_categories] if params[:product] && params[:product][:product_categories]
							end
						else
							return {}
						end
					end

				end
			end
		end
	end
end
