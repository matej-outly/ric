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

					end

					#
					# Index action
					#
					def index
						@products = RicAssortment.product_model.all.order(position: :asc).page(params[:page]).per(50)
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

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_params
						permitted_params = []
						RicAssortment.product_model.parts.each do |part|
							permitted_params.concat(self.method("product_#{part.to_s}_params".to_sym).call)
						end
						params.require(:product).permit(permitted_params)
					end

					def product_identification_params
						[:name, :catalogue_number, :ean]
					end

					def product_content_params
						[:perex, :content]
					end

					def product_dimensions_params
						[:height, :width, :depth, :weight]
					end

					def product_price_params
						[:price, :unit]
					end

					def product_meta_params
						[:description, :keywords]
					end

				end
			end
		end
	end
end
