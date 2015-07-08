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
			module Public
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
						before_action :set_product, only: [:show]

						#
						# Set product category before some actions
						#
						before_action :set_product_category, only: [:index, :show]

					end

					#
					# Index action
					#
					def index
						@products = RicAssortment.product_model.from_category(params[:product_category_id]).order(position: :asc).page(params[:page]).per(24)
					end

					#
					# Show action
					#
					def show
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
						end
					end

				end
			end
		end
	end
end
