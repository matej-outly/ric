# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Cart
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	module Concerns
		module Controllers
			module Public
				module CartController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_cart, only: [:get, :add, :remove, :clear]

					end

					#
					# Get entire cart
					#
					def get
						render :json => @cart
					end

					#
					# Add product to cart
					#
					def add
						my_params = cart_item_params
						my_params = process_sub_product_ids(my_params)
						my_params = process_product_variants(my_params)
						
						@cart.add(my_params)
						result = @cart.save
						respond_to do |format|
							format.html do 
								if result
									flash[:notice] = I18n.t("activerecord.notices.models.#{RicEshop.cart_model.model_name.i18n_key}.add")
								else
									flash[:alert] = I18n.t("activerecord.errors.models.#{RicEshop.cart_model.model_name.i18n_key}.add")
								end
								if params[:return_path]
									redirect_to params[:return_path]
								elsif request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							end
							format.json do 
								if result
									render :json => true
								else
									render :json => @cart.errors
								end
							end
						end
					end

					#
					# Remove product from cart
					#
					def remove
						my_params = cart_item_params
						my_params = process_sub_product_ids(my_params)
						my_params = process_product_variants(my_params)

						@cart.remove(my_params)
						result = @cart.save
						respond_to do |format|
							format.html do 
								if result
									flash[:notice] = I18n.t("activerecord.notices.models.#{RicEshop.cart_model.model_name.i18n_key}.remove")
								else
									flash[:alert] = I18n.t("activerecord.errors.models.#{RicEshop.cart_model.model_name.i18n_key}.remove")
								end
								if params[:return_path]
									redirect_to params[:return_path]
								elsif request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							end
							format.json do 
								if result
									render :json => true
								else
									render :json => @cart.errors
								end
							end
						end
					end

					#
					# Clear entire cart
					#
					def clear
						@cart.clear
						respond_to do |format|
							format.html do
								flash[:notice] = I18n.t("activerecord.notices.models.#{RicEshop.cart_model.model_name.i18n_key}.clear")
								if params[:return_path]
									redirect_to params[:return_path]
								elsif request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							end
							format.json do
								render :json => true
							end
						end
					end

				protected

					#
					# Find model according to parameter
					#
					def set_cart
						@cart = RicEshop.cart_model.find(RicEshop.session_model.current_id(session))
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def cart_item_params
						params.permit([:product_id, :sub_product_ids].concat(params.keys.select { |key| key.to_s.start_with?("product_variant_") }))
					end

					def process_sub_product_ids(params)
						if params[:sub_product_ids] && !params[:sub_product_ids].is_a?(Array)
							params[:sub_product_ids] = params[:sub_product_ids].to_s.split(",")
						end
						return params
					end

					def process_product_variants(params)
						if params[:sub_product_ids].is_a?(Array)
							sub_product_ids = params[:sub_product_ids]
						else
							sub_product_ids = []
						end
						params.each do |key, value|
							if key.to_s.start_with?("product_variant_")
								sub_product_ids << value
								params.delete(key)
							end
						end
						params[:sub_product_ids] = sub_product_ids
						return params
					end

				end
			end
		end
	end
end
