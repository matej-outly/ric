# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Dummy payment backend
# *
# * Author: Matěj Outlý
# * Date  : 20. 2. 2016
# *
# *****************************************************************************

require "singleton"

require "ric_payment/backends/dummy/payment"

module RicPayment
	module Backends
		class Dummy
			include Singleton

			# *****************************************************************
			# Payment retrieve
			# *****************************************************************

			#
			# Create new payment
			#
			def create_payment(payment_subject)
				payment = Payment.new
				payment.create
				return payment
			end

			def parse(params)
				payment = Payment.new
				return payment
			end

			# *****************************************************************
			# URLs
			# *****************************************************************

			#
			# Set success URL
			#
			def success_url=(success_url)
			end

			#
			# Set failed URL
			#
			def failed_url=(failed_url)
			end

		end
	end
end