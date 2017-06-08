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
			result = payment.load_from_subject(payment_subject)
			if result
				return payment
			else
				return nil
			end
		end

		#
		# Create payment defined by request params
		#
		def payment_from_params(params)
			payment = self.payment_factory
			result = payment.load_from_params(params)
			if result
				return payment
			else
				return nil
			end
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

		#
		# Redirect URL for the given payment
		#
		def redirect_url(payment, params, options = {})
			
			# Get method ID
			method_id = nil
			method_id = params["tp_radio_value"] if !params["tp_radio_value"].blank?
			method_id = options[:forced_value] if options[:forced_value]

			# Check method ID
			if method_id.nil?
				return nil
			end

			# Set method ID to payment
			payment.method_id = method_id

			# Generate URL
			url = Config.gate_url + '?' + payment.query
			return url
		end

	end
end
