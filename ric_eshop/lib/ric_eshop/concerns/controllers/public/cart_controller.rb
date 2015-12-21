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
						if my_params[:sub_product_ids]
							my_params[:sub_product_ids] = my_params[:sub_product_ids].split(",")
						end
						puts my_params.inspect
						@cart.add(my_params)
						result = @cart.save
						respond_to do |format|
							format.html do 
								if result
									flash[:notice] = I18n.t("activerecord.notices.models.#{RicEshop.cart_model.model_name.i18n_key}.add")
								else
									flash[:alert] = I18n.t("activerecord.errors.models.#{RicEshop.cart_model.model_name.i18n_key}.add")
								end
								if request.referer 
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
						if my_params[:sub_product_ids]
							my_params[:sub_product_ids] = my_params[:sub_product_ids].split(",")
						end
						puts my_params.inspect
						@cart.remove(my_params)
						result = @cart.save
						respond_to do |format|
							format.html do 
								if result
									flash[:notice] = I18n.t("activerecord.notices.models.#{RicEshop.cart_model.model_name.i18n_key}.remove")
								else
									flash[:alert] = I18n.t("activerecord.errors.models.#{RicEshop.cart_model.model_name.i18n_key}.remove")
								end
								if request.referer 
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
								if request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							end
							format.json { render :json => true }
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
						params.permit(:product_id, :sub_product_ids)
					end

				end
			end
		end
	end
end
