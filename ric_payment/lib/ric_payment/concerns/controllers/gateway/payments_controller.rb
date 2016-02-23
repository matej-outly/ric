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
						# Set backend before some actions
						#
						before_action :set_backend, only: [:notify]

					end

					#
					# Notify change of payment state
					#
					def notify
						
						# Create payment
						payment = @backend.parse(params)

						# Get order based on order id
						payment_subject = RicPayment.payment_subject_model.payment(payment).first

						if !payment_subject.nil?

							if !payment_subject.paid?

								# Read status
								status = @backend.read_status(identity, payment_subject.id, payment_subject.payment_label)

								if payment.status == :paid # Payment sucessfully finished

									# In transaction
									payment_subject.transaction do

										# Log
										Rails.logger.info("gateway/payments#notify: #{RicPayment.payment_subject_model.to_s}.id=" + payment_subject.id.to_s + " #{RicPayment.payment_subject_model.to_s}.payment_session_id=" + payment_subject.payment_session_id.to_s + ": Success")
										
										# Pay
										payment_subject.pay
										
									end

								elsif payment.status == :canceled || payment.status == :timeouted || payment.status == :refunded # Payment canceled, timeouted or refunded

									# Cancel payment
									payment_subject.cancel_payment

								else # Unknown state

									# Error
									Rails.logger.info("gateway/payments#notify: #{RicPayment.payment_subject_model.to_s}.id=" + payment_subject.id.to_s + " #{RicPayment.payment_subject_model.to_s}.payment_session_id=" + payment_subject.payment_session_id.to_s + ": Unknown state")

								end

							else # Already paid

								# Error
								Rails.logger.info("gateway/payments#notify: #{RicPayment.payment_subject_model.to_s}.id=" + payment_subject.id.to_s + " #{RicPayment.payment_subject_model.to_s}.payment_session_id=" + payment_subject.payment_session_id.to_s + ": Already paid")

							end

						else # Order not found

							# Error
							Rails.logger.info("gateway/payments#notify: #{RicPayment.payment_subject_model.to_s}.id=" + identity.orderNumber.to_s + " #{RicPayment.payment_subject_model.to_s}.payment_session_id=" + identity.paymentSessionId.to_s + ": Not found")

						end

						# Send result code 200 to acknowledge status change
						head :ok

					end

				protected

					#
					# Set backend API
					#
					def set_backend
						@backend = RicPayment.backend.instance
					end

				end
			end
		end
	end
end
