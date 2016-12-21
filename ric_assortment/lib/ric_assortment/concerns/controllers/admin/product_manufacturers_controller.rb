# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product manufacturers
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductManufacturersController extend ActiveSupport::Concern

					included do
					
						before_action :set_product_manufacturer, only: [:show, :edit, :update, :destroy]

					end

					def index
						@product_manufacturers = RicAssortment.product_manufacturer_model.all.order(name: :asc)
					end

					def search
						@product_manufacturers = RicAssortment.product_manufacturer_model.search(params[:q]).order(name: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @product_manufacturers.to_json }
						end
					end

					def show
						respond_to do |format|
							format.json { render json: @product_manufacturer.to_json(methods: :logo_url) }
						end
					end

					def new
						@product_manufacturer = RicAssortment.product_manufacturer_model.new
					end

					def edit
					end

					def create
						@product_manufacturer = RicAssortment.product_manufacturer_model.new(product_manufacturer_params)
						if @product_manufacturer.save
							respond_to do |format|
								format.html { redirect_to product_manufacturers_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_manufacturer_model.model_name.i18n_key}.create") }
								format.json { render json: @product_manufacturer.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @product_manufacturer.errors }
							end
						end
					end

					def update
						if @product_manufacturer.update(product_manufacturer_params)
							respond_to do |format|
								format.html { redirect_to product_manufacturers_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_manufacturer_model.model_name.i18n_key}.update") }
								format.json { render json: @product_manufacturer.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @product_manufacturer.errors }
							end
						end
					end

					def destroy
						@product_manufacturer.destroy
						respond_to do |format|
							format.html { redirect_to product_manufacturers_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_manufacturer_model.model_name.i18n_key}.destroy") }
							format.json { render json: @product_manufacturer.id }
						end
						
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_product_manufacturer
						@product_manufacturer = RicAssortment.product_manufacturer_model.find_by_id(params[:id])
						if @product_manufacturer.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_manufacturer_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************

					def product_manufacturer_params
						result = params.require(:product_manufacturer).permit(RicAssortment.product_manufacturer_model.permitted_columns)
						return result
					end

				end
			end
		end
	end
end
