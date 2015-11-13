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

					end

					#
					# New action
					#
					def new
						@cart = RicEshop.cart_model.find(session_id)
						@order = RicEshop.order_model.new(session_id: session_id)
						if @cart.empty?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.cart_empty")
						end
					end

					#
					# Create action
					#
					def create
						@cart = RicEshop.cart_model.find(session_id)
						@order = RicEshop.order_model.new(order_params)
						if @order.save
							redirect_to order_created_path, notice: I18n.t("activerecord.notices.models.#{RicEshop.order_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

				protected

					#
					# Get path which should be followed after order is succesfully created
					#
					def order_created_path
						main_app.root_path
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
