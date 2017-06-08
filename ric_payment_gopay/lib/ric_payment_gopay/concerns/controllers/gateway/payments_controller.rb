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
			module Gateway
				module PaymentsController extend ActiveSupport::Concern
					
					included do
					
						before_action :set_backend, only: [:notify]

					end

					def notify
						
						# Create payment object
						@payment = @backend.payment_from_params(params)

						# Get order based on order and payment ID
						@payment_subject = RicPayment.payment_subject_model.where(id: @payment.order_number, payment_id: @payment.id).first

						if !@payment_subject.nil?

							if !@payment_subject.paid?

								# Load additional attributes known in payment subject (such as value, currency, description, etc.). Needed for payment state check.
								@payment.load_from_subject(@payment_subject)

								# Read status
								status = @backend.get_payment_state(@payment) 

								if status == RicPaymentGopay::Backend::Payment::STATUS_PAID # Payment sucessfully finished

									# In transaction
									@payment_subject.transaction do

										# Log
										Rails.logger.info("ric_payment_gopay/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{@payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{@payment_subject.payment_id.to_s}: Success")
										
										# Pay
										@payment_subject.pay
										
									end

								elsif status == RicPaymentGopay::Backend::Payment::STATUS_CANCELED || 
									  status == RicPaymentGopay::Backend::Payment::STATUS_TIMEOUT ||
									  status == RicPaymentGopay::Backend::Payment::STATUS_REFUNDED ||
									  status == RicPaymentGopay::Backend::Payment::STATUS_PARTIALLY_REFUNDED # Payment canceled, timeout or refunded

									# Log
									Rails.logger.info("ric_payment_gopay/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{@payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{@payment_subject.payment_id.to_s}: Canceled")
										
									# Cancel payment
									@payment_subject.cancel_payment

								else # Unknown state

									# Error
									Rails.logger.info("ric_payment_gopay/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{@payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{@payment_subject.payment_id.to_s}: Unknown state")

								end

							else # Already paid

								# Error
								Rails.logger.info("ric_payment_gopay/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{@payment_subject.id.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{@payment_subject.payment_id.to_s}: Already paid")

							end

						else # Payment subject not found

							# Error
							Rails.logger.info("ric_payment_gopay/gateway_payments#notify: #{RicPayment.payment_subject_model.to_s}.id=#{@payment.order_number.to_s},#{RicPayment.payment_subject_model.to_s}.payment_id=#{@payment.id.to_s}: Payment subject not found")

						end

						# Send result code 200 to acknowledge status change
						head :ok

					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_backend
						@backend = RicPaymentGopay::Backend.instance
					end

				end
			end
		end
	end
end
