# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payments - this controller is typically rewritten inside the aplication 
# * checkout controllers and possibly combined with other payment backends.
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	module Concerns
		module Controllers
			module Public
				module PaymentsController extend ActiveSupport::Concern

					included do
					
						before_action :set_payment_subject, only: [:new, :success, :failed]
						before_action :set_backend, only: [:new, :success, :failed]

					end

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

					def success
						redirect_to success_path, notice: I18n.t("activerecord.notices.models.ric_payment/payment.success")
					end

					def failed
						redirect_to failed_path, alert: I18n.t("activerecord.errors.models.ric_payment/payment.failed")
					end

				protected

					# *********************************************************
					# Paths
					# *********************************************************

					#
					# Success path to be overriden in the aplication
					#
					def success_path
						main_app.root_path
					end

					#
					# Failed path to be overriden in the aplication
					#
					def failed_path
						main_app.root_path
					end

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
						@backend = RicPaymentFerbuy::Backend.instance
						@backend.success_url = ric_payment_ferbuy_public.success_payment_url(@payment_subject)
						@backend.failed_url = ric_payment_ferbuy_public.failed_payment_url(@payment_subject)
					end

				end
			end
		end
	end
end
