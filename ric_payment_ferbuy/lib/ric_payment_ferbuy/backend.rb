# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Backend
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

require "singleton"

# Backend parts
require "ric_payment_ferbuy/backend/config"
require "ric_payment_ferbuy/backend/checksum"
require "ric_payment_ferbuy/backend/payment"
require "ric_payment_ferbuy/backend/api"

module RicPaymentFerbuy
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
			payment.return_url_ok = self.success_url
			payment.return_url_cancel = self.failed_url
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
		# API
		# *****************************************************************

		#
		# Get payment state
		#
		def get_payment_state(payment)
			api = Api.instance
			response = api.transaction(payment.id)
			return response.status
		end

		# *****************************************************************
		# URLs
		# *****************************************************************

		#
		# Success URL for this gateway
		#
		attr_accessor :success_url

		#
		# Fail and cancel URL for this gateway
		#
		attr_accessor :failed_url

	end
end
