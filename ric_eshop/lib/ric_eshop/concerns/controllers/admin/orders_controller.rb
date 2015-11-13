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
			module Admin
				module OrdersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set order before some actions
						#
						before_action :set_order, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@orders = Order.order(created_at: :desc).page(params[:page])
					end

					#
					# Show action
					#
					def show
					end

					#
					# Edit action
					#
					def edit
						if @order.locked?
							redirect_to order_path(@order), alert: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.locked")
						end
					end

					#
					# Update action
					#
					def update
						if @order.locked?
							redirect_to order_path(@order), alert: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.locked")
						else
							@order.override_accept_terms
							if @order.update(order_params)
								redirect_to order_path(@order), notice: I18n.t("activerecord.notices.models.#{RicEshop.order_model.model_name.i18n_key}.update")
							else
								render "edit"
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						if @order.locked?
							redirect_to order_path(@order), alert: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.locked")
						else
							@order.destroy
							redirect_to orders_path, notice: I18n.t("activerecord.notices.models.#{RicEshop.order_model.model_name.i18n_key}.destroy")
						end
					end

				private

					#
					# Find model according to parameter
					#
					def set_order
						@order = Order.find_by_id(params[:id])
						if @order.nil?
							redirect_to orders_path, error: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def order_params
						params.require(:order).permit(:customer_id, :customer_name, :customer_email, :customer_phone, :billing_name, :currency, :payment_type, :delivery_type, :note, :billing_address => [:street, :number, :postcode, :city])
					end

				end
			end
		end
	end
end
