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

					included do
					
						before_action :set_product_category, only: [:show, :edit, :update, :move_up, :move_down, :destroy]

					end

					def index
						@product_categories = RicAssortment.product_category_model.all.order(lft: :asc)
					end

					def search
						@product_categories = RicAssortment.product_category_model.search(params[:q]).order(lft: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @product_categories.to_json }
						end
					end

					def show
					end

					def new
						@product_category = RicAssortment.product_category_model.new
					end

					def edit
					end

					def create
						@product_category = RicAssortment.product_category_model.new(product_category_params)
						if @product_category.save
							redirect_to product_category_path(@product_category), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					def update
						if @product_category.update(product_category_params)
							redirect_to product_category_path(@product_category), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					def move_up
						@product_category.move_left
						respond_to do |format|
							format.html { redirect_to product_categories_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.move") }
							format.json { render json: @product_category.id }
						end
					end

					def move_down
						@product_category.move_right
						respond_to do |format|
							format.html { redirect_to product_categories_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.move") }
							format.json { render json: @product_category.id }
						end
					end

					def destroy
						@product_category.destroy
						redirect_to product_categories_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_category_model.model_name.i18n_key}.destroy")
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_product_category
						@product_category = RicAssortment.product_category_model.find_by_id(params[:id])
						if @product_category.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_category_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************
					
					def product_category_params
						params.require(:product_category).permit(RicAssortment.product_category_model.permitted_columns)
					end

				end
			end
		end
	end
end
