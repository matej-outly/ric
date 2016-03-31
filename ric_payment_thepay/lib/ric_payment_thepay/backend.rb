# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Backend
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

require "singleton"

# Backend parts
require "ric_payment_thepay/backend/config"
require "ric_payment_thepay/backend/payment"

module RicPaymentThepay
	class Backend
		include Singleton
		
		# *****************************************************************
		# Payment retrieve
		# *****************************************************************

		#
		# Create new payment (factory)
		#
		def payment_factory
			payment = Payment.new
			payment.return_url = self.success_url # Success and failed URL is the same for this gateway
			return payment
		end

		#
		# Create payment defined by payment subject
		#
		def payment_from_subject(payment_subject)	
			payment = self.payment_factory
			payment.value = payment_subject.payment_value
			payment.description = payment_subject.payment_label
			payment.currency = Backend.locale_to_currency(payment_subject.payment_currency)
			# TODO other attributes
			return payment
		end

		#
		# Create payment defined by request params
		#
		def payment_from_params(params)
			payment = self.payment_factory
			# TODO
			return payment
		end

		# *****************************************************************
		# URLs
		# *****************************************************************

		attr_accessor :success_url
		def success_url=(success_url)
			@success_url = success_url
			@failed_url = success_url # Success and failed URL is the same for this gateway
		end

		attr_accessor :failed_url
		def failed_url=(failed_url)
			@failed_url = failed_url
			@success_url = failed_url # Success and failed URL is the same for this gateway
		end

	protected

		#
		# Translate locale to currency identifier used in ThePay system
		#
		def self.locale_to_currency(locale)
			locale_to_currency = {
				"cs" => "CZK"	
			}
			return locale_to_currency[locale.to_s] if locale_to_currency[locale.to_s]
			return "CZK"
		end

	end
end
