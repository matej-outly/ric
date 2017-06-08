# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment object
# *
# * Author: Matěj Outlý
# * Date  : 8. 6. 2017
# *
# *****************************************************************************

require "paypal-sdk-rest"

module RicPaymentPaypal
	class Backend
		class Payment

			def initialize(backend)
				@backend = backend
			end

			def id
				@payment.id	
			end

			# *****************************************************************
			# Params returned from gateway
			# *****************************************************************

			def load_from_params(params)
				@payment = PayPal::SDK::REST::DataTypes::Payment.find(params[:paymentId])
				@payer_id = params[:PayerID]
				return self
			end

			# *****************************************************************
			# Payment subject
			# *****************************************************************

			def load_from_subject(payment_subject)
				@payment = PayPal::SDK::REST::DataTypes::Payment.new({
					:intent =>  "sale",

					# Set payment type
					:payer =>  {
						:payment_method =>  "paypal"
					},

					# Set redirect urls
					:redirect_urls => {
						:return_url => @backend.success_url,
						:cancel_url => @backend.failed_url
					},

					# Set transaction object
					:transactions =>  [{

						# Amount - must match item list breakdown price
						:amount =>  {
							:total =>  payment_subject.payment_price,
							:currency =>  Payment.locale_to_currency(payment_subject.payment_currency)
						},

						:description =>  payment_subject.payment_description
					}]
				})
				return self
			end

			# *****************************************************************
			# Lifecycle
			# *****************************************************************

			def create
				if @payment.nil?
					raise "Payment must be first loaded before creating."
				end
				if @payment.create
					@redirect_url = payment.links.find{|v| v.rel == "approval_url" }.href # Capture redirect url
					return true
				else
					return false
				end
			end

			def execute
				if @payment.nil?
					raise "Payment must be first loaded before executing."
				end
				if @payer_id.nil?
					raise "Payment must be loaded from params before executing."
				end
				return @payment.execute(payer_id: @payer_id)
			end

			# *****************************************************************
			# URLs
			# *****************************************************************

			def redirect_url
				if @redirect_url.nil?
					raise "Payment must be first created before redirecting."
				end
				return @redirect_url
			end

		protected

			#
			# Translate locale to currency identifier used in ThePay system
			#
			def self.locale_to_currency(locale)
				locale_to_currency = {
					"cs" => "CZK",
					"sk" => "EUR"
				}
				return locale_to_currency[locale.to_s] if locale_to_currency[locale.to_s]
				return Config.default_currency
			end

		end
	end
end