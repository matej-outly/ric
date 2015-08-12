# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product ticker relations
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductTickerRelationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do

						#
						# Set product ticker before some actions
						#
						before_action :set_product_ticker, only: [:edit, :update, :destroy]

						#
						# Set product before some actions
						#
						before_action :set_product, only: [:destroy]

					end

					#
					# New action
					#
					def edit
						@products = RicAssortment.product_model.all.order(position: :asc)
					end

					#
					# Create action
					#
					def update
						param_products = product_ticker_params[:products]
						@product_ticker.product_ids = ((!param_products.nil? && param_products.is_a?(Hash)) ? param_products.keys : [])
						redirect_to product_ticker_path(@product_ticker), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_ticker_model.model_name.i18n_key}.product_bind")
					end

					#
					# Destroy action
					#
					def destroy
						@product_ticker.products.delete(@product)
						redirect_to product_ticker_path(@product_ticker), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_ticker_model.model_name.i18n_key}.product_unbind")
					end

				protected

					def set_product_ticker
						@product_ticker = RicAssortment.product_ticker_model.find_by_id(params[:id])
						if @product_ticker.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_ticker_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:product_id])
						if @product.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_ticker_params
						if params[:product_ticker]
							params[:product_ticker].tap do |white_listed|
								white_listed[:products] = params[:product_ticker][:products] if params[:product_ticker] && params[:product_ticker][:products]
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
