# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product categories
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductCategoriesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product_category, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@product_categories = RicAssortment.product_category_model.all.order(lft: :asc)
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
						@product_category = RicAssortment.product_category_model.new
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
						@product_category = RicAssortment.product_category_model.new(product_category_params)
						if @product_category.save
							redirect_to product_category_path(@product_category), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product_category.update(product_category_params)
							redirect_to product_category_path(@product_category), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_category.destroy
						redirect_to product_categories_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_category
						@product_category = RicAssortment.product_category_model.find_by_id(params[:id])
						if @product_category.nil?
							redirect_to product_categories_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_category_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_category_params
						params.require(:product_category).permit(:name, :parent_id)
					end

				end
			end
		end
	end
end
