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
						before_action :set_order, only: [:new, :create]

					end

					#
					# Reset action
					#
					def reset
						clear_session
						redirect_to main_app.root_path
					end

					#
					# New action
					#
					def new
						if @cart.empty?
							redirect_to order_empty_path, alert: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.cart_empty")
						end
					end

					#
					# Preserve action
					#
					#def preserve
						#save_params_to_session(order_params)
						#respond_to do |format|
						#	format.html { redirect_to ric_eshop_public.new_order_path }
						#	format.json { render json: true }
						#end
					#end

					#
					# Create action
					#
					def create
						
						# Next step or save
						if @order.valid?
							if params[:back_button]
								@order.previous_step
							elsif @order.last_step?
								if @order.all_valid?
									@order.save
								end
							else
								@order.next_step
							end
							save_step_to_session(@order.current_step)
						end

						# Save errors
						save_errors_to_session(@order.errors)

						# Render form or redirect
						if @order.new_record?

							# Next step or errors in current step
							redirect_to ric_eshop_public.new_order_path
						else

							# All done
							redirect_to order_created_path, notice: I18n.t("activerecord.notices.models.#{RicEshop.order_model.model_name.i18n_key}.create")

							# Order is complete => session can be deleted
							clear_session
						end

					end

					#
					# Finalize action
					#
					def finalize
						@order = RicEshop.order_model.find_by_id(params[:id])
						if @order.nil?
							redirect_to main_app.root_path, error: I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.not_found")
						end
					end

				protected

					# *********************************************************************
					# Default values
					# *********************************************************************

					def set_order_default_values_for_new_session
					end

					def set_order_default_values_for_existing_session
						@order.cart_price = @cart.price # In order to validate minimal price conditions 
					end

					# *********************************************************************
					# Model setters
					# *********************************************************************

					def set_order

						# Store new session flag
						new_session = new_session?

						# Save param changes to session
						save_params_to_session(load_params_from_session.merge!(order_params))

						# Create order object
						@order = RicEshop.order_model.new
						@order.assign_attributes(load_params_from_session)
						@order.current_step = load_step_from_session
						load_errors_from_session(@order.errors)
						
						# Set session ID to cart bind
						@order.session_id = @cart.session_id
						
						# Default valued
						if new_session
							set_order_default_values_for_new_session
						else
							set_order_default_values_for_existing_session
						end
					end

					def set_cart
						@cart = RicEshop.cart_model.find(RicEshop.session_model.current_id(session))
					end

					# *********************************************************************
					# Path resolvers
					# *********************************************************************

					#
					# Get path which should be followed if order is empty
					#
					def order_empty_path
						main_app.root_path
					end

					#
					# Get path which should be followed after order is succesfully created
					#
					def order_created_path
						ric_eshop_public.finalize_order_path(@order)
					end

					# *********************************************************************
					# Session
					# *********************************************************************

					def session_key
						return "orders"
					end

					def clear_session
						session.delete(session_key)
					end

					def new_session?
						return session[session_key].nil?
					end

					def save_params_to_session(params)
						session[session_key] = {} if session[session_key].nil?
						session[session_key]["params"] = params if !params.nil?
					end

					def load_params_from_session
						return session[session_key]["params"] if !session[session_key].nil? && !session[session_key]["params"].nil?
						return {}
					end

					def clear_params_from_session
						session[session_key].delete("params") if !session[session_key].nil? && !session[session_key]["params"].nil?
					end

					def save_step_to_session(step)
						session[session_key] = {} if session[session_key].nil?
						session[session_key]["step"] = step if !step.nil?
					end

					def load_step_from_session
						return session[session_key]["step"] if !session[session_key].nil? && !session[session_key]["step"].nil?
						return nil
					end

					def clear_step_from_session
						session[session_key].delete("step") if !session[session_key].nil? && !session[session_key]["step"].nil?
					end

					def save_errors_to_session(errors)
						session[session_key] = {} if session[session_key].nil?
						session[session_key]["errors"] = errors.messages if !errors.nil?
					end

					def load_errors_from_session(errors)
						if !errors.nil?
							errors.clear
							if !session[session_key].nil? && !session[session_key]["errors"].nil?
								session[session_key]["errors"].each do |column, messages|
									messages.each do |message|
										errors.add(column, message)
									end
								end
							end
						end
					end

					def clear_errors_from_session
						session[session_key].delete("errors") if !session[session_key].nil? && !session[session_key]["errors"].nil?
					end

					# *********************************************************************
					# Param filters
					# *********************************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def order_params
						if params[:order]
							return params[:order].permit(
								:session_id, 
								:customer_id, 
								:customer_name, 
								:customer_email, 
								:customer_phone, 
								:billing_name, 
								:currency, 
								:payment_type, 
								:delivery_type, 
								:accept_terms, 
								:note, 
								:billing_address => [:street, :number, :postcode, :city]
							)
						else
							return {}
						end
					end

				end
			end
		end
	end
end
