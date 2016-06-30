# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	module Concerns
		module Controllers
			module Gateway
				module PaymentsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set backend before some actions
						#
						before_action :set_backend, only: [:notify]

						#
						# No token verification
						#
						skip_before_action :verify_authenticity_token

					end

					#
					# Notify change of payment state
					#
					def notify
						
						# Create payment object
						payment = @backend.payment_from_params(params)

						# Check if payment found
						if !payment.nil?

							# Verify if returned checksum is correct
							if payment.verify_notification_checksum

								# Get order based on order
								payment_subject = RicPayment.payment_subject_model.where(id: payment.order_number).first

								if !payment_subject.nil?

									# Save payment ID into the payment subject if not yet associated
									if !payment_subject.payment_in_progress?
										payment_subject.initialize_payment(payment)
									end

									# Now we can trust payment data (except payment status)

									# Status can be double-checked via Data API
									#status = @backend.get_payment_state(payment)
									status = payment.status
									
									if !payment_subject.paid?
									
										if status == RicPaymentFerbuy::Backend::Payment::STATUS_SUCCESSFUL || 
										   status == RicPaymentFerbuy::Backend::Payment::STATUS_SUCCESSFUL_AWAITING # Payment sucessfully finished
											
											# In transaction
											payment_subject.transaction do

												# Log
												Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{payment_subject.payment_id.to_s}: Success")
												
												# Store payment ID
												payment_id = payment_subject.payment_id

												# Pay
												payment_subject.pay

												# Mark order shipped
												RicPaymentFerbuy::Backend::Api.instance.mark_order_shipped(payment_id, "OWN", "OWN")
												
											end

										elsif status == RicPaymentFerbuy::Backend::Payment::STATUS_FAILED || 
											  status == RicPaymentFerbuy::Backend::Payment::STATUS_TIMED_OUT ||
											  status == RicPaymentFerbuy::Backend::Payment::STATUS_REFUND ||
											  status == RicPaymentFerbuy::Backend::Payment::STATUS_CANCELED_CONSUMER ||
											  status == RicPaymentFerbuy::Backend::Payment::STATUS_CANCELED_MERCHANT # Payment canceled, timeout or refunded

											# Log
											Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{payment_subject.payment_id.to_s}: Canceled")
												
											# Cancel payment
											payment_subject.cancel_payment

										else # Unknown state

											# Error
											Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{payment_subject.payment_id.to_s}: Unknown state")

										end

									else

										# Error
										Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{payment_subject.payment_id.to_s}: Already paid")

									end
								
								else

									# Error
									Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{payment.order_number.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{payment.id.to_s}: Payment subject not found")

								end

							else

								# Error
								Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.payment_id=#{payment.id.to_s}: Payment not verified")

							end

						else

							# Error
							Rails.logger.info("ric_payment_ferbuy/gateway_payments#notify: Payment not found")

						end

						# Send result code 200 to acknowledge status change
						if !payment.nil?
							render :text => "#{payment.transaction_id}.#{payment.status}"
						else
							head :ok
						end
					end

				protected

					#
					# Set backend API
					#
					def set_backend
						@backend = RicPaymentFerbuy::Backend.instance
					end

				end
			end
		end
	end
end