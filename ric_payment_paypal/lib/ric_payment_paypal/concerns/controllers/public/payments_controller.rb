# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments - this controller is typically rewritten inside the aplication 
# * checkout controllers and possibly combined with other payment backends.
# *
# * Author: Matěj Outlý
# * Date  : 8. 6. 2017
# *
# *****************************************************************************

module RicPaymentPaypal
	module Concerns
		module Controllers
			module Public
				module PaymentsController extend ActiveSupport::Concern
					
					included do
					
						before_action :set_payment_subject
						before_action :set_backend, only: [:new, :done]

					end

					def create

						# Already paid or in progress => exit
						if @payment_subject.payment_in_progress?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.in_progress")
							return
						elsif @payment_subject.paid?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.paid")
							return
						end

						# Create payment object
						payment = @backend.payment_from_subject(@payment_subject)

						# Create payment and redirect
						if @backend.create_payment(payment)
							redurect_to @backend.redirect_url(payment, params)
						else
							redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.ric_payment/payment.failed")
						end
					end

					def done
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_payment_subject
						@payment_subject = RicPayment.payment_subject_model.find_by_id(params[:id])
						if @payment_subject.nil?
							redirect_to main_app.root_path, error: I18n.t("activerecord.errors.models.#{RicPayment.payment_subject_model.model_name.i18n_key}.not_found")
						end
					end

					def set_backend
						@backend = RicPaymentPaypal::Backend.instance
						@backend.success_url = ric_payment_gateway.success_payment_url(@payment_subject)
						@backend.failed_url = ric_payment_gateway.failed_payment_url(@payment_subject)
					end

				end
			end
		end
	end
end
