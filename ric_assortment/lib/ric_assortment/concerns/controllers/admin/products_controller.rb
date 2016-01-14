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

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product, only: [:show, :edit, :update, :duplicate, :destroy]

						#
						# Set product category before some actions
						#
						before_action :set_product_category, only: [:index, :from_category, :show]

						#
						# Set products before some actions
						#
						before_action :set_products, only: [:index, :from_category]

					end

					#
					# Index action
					#
					def index
					end

					#
					# From category action
					#
					def from_category
						render "index"
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
						@product = RicAssortment.product_model.new
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
						@product = RicAssortment.product_model.new(product_params)
						if @product.save
							redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product.update(product_params)
							redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Move action
					#
					def move
						if RicAssortment.product_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to products_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to products_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
	
					#
					# Duplicate action
					#
					def duplicate
						new_product = @product.duplicate
						redirect_to product_path(new_product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.duplicate")
					end

					#
					# Destroy action
					#
					def destroy
						@product.destroy
						redirect_to products_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:id])
						if @product.nil?
							redirect_to products_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product_category
						if params[:product_category_id]
							@product_category = RicAssortment.product_category_model.find_by_id(params[:product_category_id])
						elsif @product
							@product_category = @product.default_product_category
						end
					end

					def set_products
						@products = RicAssortment.product_model.from_category(params[:product_category_id]).order(position: :asc).page(params[:page]).per(50)
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_params
						permitted_params = []
						RicAssortment.product_model.parts.each do |part|
							permitted_params.concat(RicAssortment.product_model.method("#{part.to_s}_part_columns".to_sym).call)
						end
						params.require(:product).permit(permitted_params)
					end

				end
			end
		end
	end
end
