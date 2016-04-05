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

module RicPaymentThepay
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
						before_action :set_payment_subject, only: [:new, :done]
						
						#
						# Set backend before some actions
						#
						before_action :set_backend, only: [:new, :done]

					end

					#
					# New action
					#
					def new

						# Already paid or in progress => exit
						if @payment_subject.payment_in_progress?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.in_progress")
							return
						elsif @payment_subject.paid?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.paid")
							return
						end

						# Create payment object
						@payment = @backend.payment_from_subject(@payment_subject)

					end

					#
					# Done/notify action
					#
					def done

						# Create payment object
						payment = @backend.payment_from_params(params)

						# Verify if returned signature is correct
						if payment.verify_returned_signature

							# Verify if merchant data contains correct payment subject ID
							if payment.merchant_data.to_i == @payment_subject.id.to_i

								# Save payment ID into the payment subject if not yet associated
								if !@payment_subject.payment_in_progress?
									@payment_subject.initialize_payment(payment)
								end

								if @payment_subject.payment_id.to_i == payment.id.to_i

									# Verify if payment subject not paid yet
									if !@payment_subject.paid?

										# Now we can trust payment data (except payment status)

										# Status can be double-checked via Data API
										#status = @backend.get_payment_state(payment.payment_id) # TODO returns incorrect status
										status = payment.status

										# Get action based on status
										action = nil
										if status == RicPaymentThepay::Backend::Payment::STATUS_OK # Payment sucessfully established and finished
											flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success")
											action = :pay
										
										elsif status == RicPaymentThepay::Backend::Payment::STATUS_WAITING # Payment sucessfully established but not finished yet 
											flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success_not_finished")
											
										elsif status == RicPaymentThepay::Backend::Payment::STATUS_CARD_DEPOSIT
											flash[:notice] = I18n.t("activerecord.notices.models.ric_payment/payment.success_deposit")
											
										elsif status == RicPaymentThepay::Backend::Payment::STATUS_CANCELED # Payment canceled
											flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.canceled")
											action = :cancel_payment

										elsif status == RicPaymentThepay::Backend::Payment::STATUS_UNDERPAID
											flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.underpaid")
											action = :cancel_payment

										else # Unknown error
											flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.failed")
											action = :cancel_payment

										end

										# Perform action
										if action == :pay
											@payment_subject.transaction do
												@payment_subject.pay
											end

										elsif action == :cancel_payment
											@payment_subject.cancel_payment

										else
											# Do nothing
										end

									else

										# Payment subject already paid
										flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.paid")

									end

								else
									
									# Payment subject not verified
									flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.not_verified")
									puts "1"

								end

							else

								# Payment subject not verified
								flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.not_verified")
								puts "2"

							end

						else

							# Payment not verified
							flash[:alert] = I18n.t("activerecord.errors.models.ric_payment/payment.not_verified")
							puts "3"

						end

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
						@backend = RicPaymentThepay::Backend.instance
						@backend.return_url = ric_payment_public.done_payment_url(@payment_subject)
					end

				end
			end
		end
	end
end
