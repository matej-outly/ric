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
						result = @cart.add(params[:id])
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
						result = @cart.remove(params[:id])
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
