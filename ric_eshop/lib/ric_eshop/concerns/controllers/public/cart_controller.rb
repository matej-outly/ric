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
						product_id = params[:product_id]
						if params[:sub_product_ids]
							sub_product_ids = params[:sub_product_ids].split(",")
						else
							sub_product_ids = nil
						end
						result = @cart.add(product_id, sub_product_ids)
						respond_to do |format|
							format.html { 
								flash[:notice] = I18n.t("activerecord.notices.models.ric_eshop/cart.add")
								if request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							}
							format.json { render :json => result }
						end
						
					end

					#
					# Remove product from cart
					#
					def remove
						product_id = params[:product_id]
						if params[:sub_product_ids]
							sub_product_ids = params[:sub_product_ids].split(",")
						else
							sub_product_ids = nil
						end
						result = @cart.remove(product_id, sub_product_ids)
						respond_to do |format|
							format.html { 
								flash[:notice] = I18n.t("activerecord.notices.models.ric_eshop/cart.remove")
								if request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							}
							format.json { render :json => result }
						end
					end

					#
					# Clear entire cart
					#
					def clear
						result = @cart.clear
						respond_to do |format|
							format.html { 
								flash[:notice] = I18n.t("activerecord.notices.models.ric_eshop/cart.clear")
								if request.referer 
									redirect_to request.referer
								else
									redirect_to main_app.root_path
								end
							}
							format.json { render :json => result }
						end
					end

				protected

					#
					# Find model according to parameter
					#
					def set_cart
						@cart = RicEshop.cart_model.find(RicEshop.session_model.current_id(session))
					end

				end
			end
		end
	end
end
