# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentGopay
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
						before_action :set_payment_subject, only: [:new, :create, :success, :failed]
						
						#
						# Set backend before some actions
						#
						before_action :set_backend, only: [:new, :create, :success]

					end

					#
					# New action
					#
					def new

						# Already paid or in progress => exit
						if @payment_subject.payment_in_progress?
							redirect_to failed_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.in_progress")
							return
						elsif @payment_subject.paid?
							redirect_to failed_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.paid")
							return
						end

						# Create payment object
						@payment = @backend.payment_from_subject(@payment_subject)

					end

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

							# Create payment object
							@payment = @backend.payment_from_subject(@payment_subject)

							# Create payment in the gateway
							@payment = @backend.create_payment(@payment)

							# Save payment ID to payment subject
							@payment_subject.initiate_payment(@payment)

							# Response
							render :json => @payment

						end

					end

					#
					# Success path for GoPay
					#
					def success

						# Create payment object
						@payment = @backend.payment_from_params(params)
						
						# Load additional attributes known in payment subject (such as value, currency, description, etc.). Needed for payment state check.
						@payment.load_from_subject(@payment_subject)

						# Read status
						status = @backend.get_payment_state(@payment) 

						if status == RicPaymentGopay::Backend::Payment::STATUS_PAID # Payment sucessfully established and finished
							flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success")

						elsif status == RicPaymentGopay::Backend::Payment::STATUS_PAYMENT_METHOD_CHOSEN # Payment sucessfully established but not finished yet (superCASH, bank account) 
							flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success_not_finished")

						elsif status == RicPaymentGopay::Backend::Payment::STATUS_CANCELED # Payment canceled
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.canceled")

						elsif status == RicPaymentGopay::Backend::Payment::STATUS_TIMEOUT # Payment timeouted
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.timeout")

						else # Unknown error
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.failed")
						end

						redirect_to success_path
					end

					#
					# Failed path for GoPay
					#
					def failed
						redirect_to failed_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.failed")
					end

				protected

					def success_path
						main_app.root_path
					end

					def failed_path
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
						@backend = RicPaymentGopay::Backend.instance
						@backend.success_url = ric_payment_public.success_payment_url(@payment_subject)
						@backend.failed_url = ric_payment_public.failed_payment_url(@payment_subject)
					end

				end
			end
		end
	end
end
