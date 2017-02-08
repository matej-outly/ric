# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Products
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductsController extend ActiveSupport::Concern

					included do
					
						before_action :set_product, only: [:show, :edit, :update, :duplicate, :move, :destroy]

					end

					def index
						@filter_product = RicAssortment.product_model.new(load_params_from_session)
						@products = RicAssortment.product_model.filter(load_params_from_session).order(position: :asc)
						if request.format.to_sym == :html
							@products = @products.page(params[:page]).per(50)
						end
						respond_to do |format|
							format.html
							#format.xls
						end
					end

					def filter
						save_params_to_session(filter_params)
						redirect_to products_path
					end

					def search
						@products = RicAssortment.product_model.search(params[:q]).order(default_product_category_id: :asc, position: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @products.to_json }
						end
					end

					def show
					end

					def new
						@product = RicAssortment.product_model.new
					end

					def edit
					end

					def create
						@product = RicAssortment.product_model.new(product_params)
						if @product.save
							redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					def update
						if @product.update(product_params)
							redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					def move
						if RicAssortment.product_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to products_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.move") }
								format.json { render json: @product.id }
							end
						else
							respond_to do |format|
								format.html { redirect_to products_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.move") }
								format.json { render json: @product.errors }
							end
						end
					end
	
					def duplicate
						new_product = @product.duplicate
						redirect_to edit_product_path(new_product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.duplicate")
					end

					def destroy
						@product.destroy
						redirect_to products_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.destroy")
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:id])
						if @product.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************

					def product_params
						if params[:product]
							result = params[:product].permit(RicAssortment.product_model.permitted_columns)
							RicAssortment.product_model.permitted_columns.select { |column| column.to_s.end_with?("_ids") }.each do |column|
								result[column] = result[column].split(",") if !result[column].blank?
							end
							result[:other_attributes] = JSON.parse(result[:other_attributes]) if !result[:other_attributes].blank?
							return result
						else
							return {}
						end
					end

					def filter_params
						return params[:product].permit(RicAssortment.product_model.filter_columns)
					end

				end
			end
		end
	end
end
