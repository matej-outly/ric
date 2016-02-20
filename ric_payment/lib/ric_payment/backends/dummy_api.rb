# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Dummy payment API
# *
# * Author: Matěj Outlý
# * Date  : 20. 2. 2016
# *
# *****************************************************************************

require "singleton"

module RicPayment
	module Backends
		class DummyAPI
			include Singleton

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

			#
			# Get correct Secure key according to environment
			#
			def secure_key
				nil
			end

			#
			# Get redirect URL
			#
			def redirect_url
				nil
			end

			#
			# Create new payment
			#
			def create_payment(order_number, product, customer, default_payment_channel)
				return 1
			end

			#
			# Create session info
			#
			def create_session_info(payment_session_id)
				return nil
			end

			# 
			# Create identity according to GET params (used as first action in gateway callback)
			#
			def create_identity(params)
				return nil
			end

			#
			# Check identity and read status
			#
			def read_status(identity, order_number, product)
				return nil
			end

			#
			# State checker
			#
			def state_paid?(status)
				return false
			end

			#
			# State checker
			#
			def state_payment_method_chosen?(status)
				return false
			end

			#
			# State checker
			#
			def state_canceled?(status)
				return false
			end

			#
			# State checker
			#
			def state_refunded?(status)
				return false
			end

			#
			# State checker
			#
			def state_timeouted?(status)
				return false
			end

			#
			# State checker
			#
			def message(status)
				return ""
			end

			#
			# State checker
			#
			def additional_message(status)
				return ""
			end
		end
	end
end