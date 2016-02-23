# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicPayment
	module Concerns
		module Controllers
			module Public
				module PaymentsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set payment subject before some actions
						#
						before_action :set_payment_subject, only: [:new, :create, :success]
						
						#
						# Set backend before some actions
						#
						before_action :set_backend, only: [:create, :success]

					end

					#
					# New action
					#
					def new

						# Already paid or in progress => exit
						if @payment_subject.payment_in_progress?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.in_progress")
						elsif @payment_subject.paid?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.paid")
						end

					end

					#
					# Create action
					#
					def create
						
						if @payment_subject.payment_in_progress?
								
							# Message
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.in_progress")

							# Response
							render :json => false

						elsif @payment_subject.paid?
							
							# Message
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.paid")

							# Response
							render :json => false

						else

							# Create payment
							@payment = @backend.create_payment(@payment_subject)
							if @payment.nil?

								# Message
								flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.bad_type")

								# Response
								render :json => false

							else

								# Save payment id to payment subject
								@payment_subject.initiate_payment(payment.id)

								# Response
								render :json => @payment

							end
						end

					end

					#
					# Success path
					#
					def success

						# Create payment
						payment = @backend.parse(params)
					
						if payment.status == :paid # Payment sucessfully established and finished
							flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success")

						elsif payment.status == :payment_method_chosen # Payment sucessfully established but not finished yet (superCASH, bank account) 
							flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success_not_finished")

						elsif payment.status == :canceled # Payment canceled
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.canceled")

						elsif payment.status == :timeouted # Payment timeouted
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.timeout")

						else # Unknown error
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.failed")
						end

						redirect_to payment_success_path
					end

					#
					# Failed path
					#
					def failed
						redirect_to payment_failed_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.failed")
					end


				protected

					#
					# Get path which should be followed after payment is succesfully created
					#
					def payment_success_path
						ric_eshop_public.finalize_order_path(@payment_subject)
					end

					#
					# Get path which should be followed after payment is failed
					#
					def payment_failed_path
						main_app.root_path
					end

					#
					# Find model according to parameter
					#
					def set_payment_subject
						@payment_subject = RicPayment.payment_subject_model.find_by_id(params[:id])
						if @payment_subject.nil?
							redirect_to main_app.root_path, error: I18n.t("activerecord.errors.models.#{RicPayment.payment_subject_model.model_name.i18n_key}.not_found")
						end
					end

					#
					# Set backend API
					#
					def set_backend
						@backend = RicPayment.backend.instance
						@backend.success_url = ric_payment_public.success_payments_url(@payment_subject)
						@backend.failed_url = ric_payment_public.failed_payments_url(@payment_subject)
					end

				end
			end
		end
	end
end
