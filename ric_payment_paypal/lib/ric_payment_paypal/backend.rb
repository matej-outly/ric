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
require "ric_payment_paypal/backend/payment"
require "ric_payment_paypal/backend/config"

module RicPaymentPaypal
	class Backend
		include Singleton
		
		def initialize
			puts "I'm being initialized!"
			
			PayPal::SDK.configure(
				:mode => Config.mode,
				:client_id => Config.client_id,
				:client_secret => Config.client_secret,
				:ssl_options => { } 
			)
			PayPal::SDK.logger = Rails.logger
		end

		# *****************************************************************
		# Payment retrieve
		# *****************************************************************

		#
		# Create new payment (factory)
		#
		def payment_factory
			payment = Payment.new(self)
			return payment
		end

		#
		# Create payment defined by payment subject
		#
		def payment_from_subject(payment_subject)
			payment = self.payment_factory
			payment.load_from_subject(payment_subject)
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
		# Lifecycle API
		# *****************************************************************

		#
		# Create payment in gateway
		#
		def create_payment(payment)
			return payment.create
		end

		#
		# Execute payment
		#
		def execute_payment(payment)
			return payment.execute
		end

		# *****************************************************************
		# URLs
		# *****************************************************************

		#
		# Success URL
		#
		attr_accessor :success_url

		#
		# Failed URL
		#
		attr_accessor :failed_url

		#
		# Redirect URL for the given payment
		#
		def redirect_url(payment, params, options = {})
			return payment.redirect_url
		end

	protected

	end
end
