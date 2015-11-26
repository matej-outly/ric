# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product panel / sub product relations
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductPanelSubProductRelationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do

						#
						# Set product panel before some actions
						#
						before_action :set_product_panel, only: [:edit, :update, :destroy]

						#
						# Set product panel before some actions
						#
						before_action :set_sub_product, only: [:destroy]

					end

					#
					# New action
					#
					def edit
						@sub_products = RicAssortment.product_model.all.order(position: :asc)
					end

					#
					# Create action
					#
					def update
						@product_panel.sub_product_ids = sub_product_ids_from_params
						redirect_to product_panel_path(@product_panel), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.sub_product_bind")
					end

					#
					# Destroy action
					#
					def destroy
						@product_panel.sub_products.delete(@sub_product)
						redirect_to product_panel_path(@product_panel), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.sub_product_unbind")
					end

				protected

					def set_product_panel
						@product_panel = RicAssortment.product_panel_model.find_by_id(params[:id])
						if @product_panel.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.not_found")
						end
					end

					def set_sub_product
						@sub_product = RicAssortment.sub_product_model.find_by_id(params[:sub_product_id])
						if @sub_product.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def sub_product_ids_from_params
						if params[:product_panel] && params[:product_panel][:sub_products] && params[:product_panel][:sub_products].is_a?(Hash)
							return params[:product_panel][:sub_products].keys
						else
							return []
						end
					end

				end
			end
		end
	end
end
