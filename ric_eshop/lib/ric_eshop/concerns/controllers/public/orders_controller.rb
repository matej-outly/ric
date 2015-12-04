# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Orders
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	module Concerns
		module Controllers
			module Public
				module OrdersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

						before_action :set_cart, only: [:new, :create]
						before_action :set_order, only: [:finalize]

					end

					#
					# New action
					#
					def new
						@order = RicEshop.order_model.new(session_id: @cart.session_id)
						if @cart.empty?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.cart_empty")
						end
					end

					#
					# Create action
					#
					def create
						@order = RicEshop.order_model.new(order_params)
						@order.cart_price = @cart.price # In order to validate minimal price conditions 
						if @order.save
							redirect_to order_created_path, notice: I18n.t("activerecord.notices.models.#{RicEshop.order_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Finalize action
					#
					def finalize
					end

				protected

					#
					# Find model according to parameter
					#
					def set_cart
						@cart = RicEshop.cart_model.find(RicEshop.session_model.current_id(session))
					end

					#
					# Find model according to parameter
					#
					def set_order
						@order = Order.find_by_id(params[:id])
						if @order.nil?
							redirect_to main_app.root_path, error: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.not_found")
						end
					end

					#
					# Get path which should be followed after order is succesfully created
					#
					def order_created_path
						ric_eshop_public.finalize_order_path(@order)
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def order_params
						params.require(:order).permit(:session_id, :customer_id, :customer_name, :customer_email, :customer_phone, :billing_name, :currency, :payment_type, :delivery_type, :accept_terms, :note, :billing_address => [:street, :number, :postcode, :city])
					end

				end
			end
		end
	end
end
