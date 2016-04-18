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
require "ric_payment_thepay/backend/query"
require "ric_payment_thepay/backend/payment"
require "ric_payment_thepay/backend/data_api"

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
			payment.return_url = self.return_url # Success, failed and notify URL is the same for this gateway
			return payment
		end

		#
		# Create payment defined by payment subject
		#
		def payment_from_subject(payment_subject)	
			payment = self.payment_factory
			payment.value = payment_subject.payment_value
			payment.currency = Backend.locale_to_currency(payment_subject.payment_currency)
			payment.description = payment_subject.payment_label
			payment.merchant_data = payment_subject.id
			payment.is_deposit = false
			# TODO other attributes
			return payment
		end

		#
		# Create payment defined by request params
		#
		def payment_from_params(params)
			payment = self.payment_factory
			payment.load_from_params(params)
			return payment
		end

		# *****************************************************************
		# Data API
		# *****************************************************************

		#
		# Get payment
		#
		def get_payment_state(payment)
			data_api = DataApi.instance
			response = data_api.get_payment_state(payment.id)
			return response.state
		end

		# *****************************************************************
		# URLs
		# *****************************************************************

		#
		# Success, failed and notify URL is the same for this gateway
		#
		attr_accessor :return_url

	end
end
