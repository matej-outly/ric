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
						before_action :set_payment_subject, only: [:new, :success, :failed]
						
						#
						# Set backend before some actions
						#
						before_action :set_backend, only: [:new, :success, :failed]

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
					# Success path for FerBuy
					#
					def success
						redirect_to success_path, notice: I18n.t("activerecord.notices.models.ric_payment/payment.success")
					end

					#
					# Failed path for FerBuy
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
						@backend = RicPaymentFerbuy::Backend.instance
						@backend.success_url = ric_payment_public.success_payment_url(@payment_subject)
						@backend.failed_url = ric_payment_public.failed_payment_url(@payment_subject)
					end

				end
			end
		end
	end
end
