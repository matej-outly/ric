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

# 3rd party library
require "ric_payment_gopay/backend/api/types"
require "ric_payment_gopay/backend/api/country_code"
require "ric_payment_gopay/backend/api/gopay_communicator"
require "ric_payment_gopay/backend/api/crypto_hlpr"
require "ric_payment_gopay/backend/api/gopay_hlpr"

# Backend parts
require "ric_payment_gopay/backend/config"
require "ric_payment_gopay/backend/payment"

module RicPaymentGopay
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
		# Data API
		# *****************************************************************

		#
		# Create payment in gateway
		#
		def create_payment(payment)
			
			# New command
			command = EPaymentCommand.new

			# Basic stuff
			command.productName = payment.description
			command.orderNumber = payment.order_number.to_s
			command.totalPrice =  (payment.value.to_f * 100) # In cents
			command.currency = payment.currency
			command.targetGoId = Config.go_id

			# Return URLs
			command.failedURL = self.failed_url
			command.successURL = self.success_url

			# Payment channels
			command.paymentChannels = GopayHlpr.new.concatPaymentChannels(Config.allowed_channels)
			command.defaultPaymentChannel = payment.channel

			# Customer data
			customer_data = ECustomerData.new
			customer_data.firstName = payment.customer.name_firstname if !payment.customer.name_firstname.nil?
			customer_data.lastName = payment.customer.name_lastname if !payment.customer.name_lastname.nil?
			customer_data.email = payment.customer.email    
			command.customerData = customer_data

			# Language
			command.lang = Config.language

			# Sign with secure key
			gopay_helper = GopayHlpr.new
			gopay_helper.sign(command, Config.secure_key)

			# Create payment
			payment_status = self.communicator.createPayment(command)
			
			# Session info
			info = EPaymentSessionInfo.new
			info.targetGoId = Config.go_id
			info.paymentSessionId = payment_status.paymentSessionId

			# Sign with secure key
			gopay_helper = GopayHlpr.new
			gopay_helper.sign(info, Config.secure_key)

			# Set payment ID, target Go ID and signature
			payment.payment_id = info.paymentSessionId
			payment.target_go_id = info.targetGoId
			payment.encrypted_signature = info.encryptedSignature
			
			return payment
		end

		#
		# Get payment status from gateway
		#
		def get_payment_state(payment)

			# Create identity
			identity = EPaymentIdentity.new
			identity.targetGoId = payment.target_go_id
			identity.orderNumber = payment.order_number
			identity.paymentSessionId = payment.id
			identity.encryptedSignature = payment.encrypted_signature

			# GoPay helper
			gopay_helper = GopayHlpr.new

			# Identity check
			gopay_helper.checkPaymentIdentity(identity, Config.go_id, payment.order_number.to_s, Config.secure_key)

			# Session info
			info = EPaymentSessionInfo.new
			info.targetGoId = Config.go_id
			info.paymentSessionId = payment.id

			# Sign with secure key
			gopay_helper = GopayHlpr.new
			gopay_helper.sign(info, Config.secure_key)

			# Get payment status
			status = self.communicator.paymentStatus(info)
			    
			# Payment status check
			gopay_helper.checkPaymentStatus(status, Config.go_id, payment.order_number.to_s, (payment.value.to_f * 100), payment.currency, payment.description, Config.secure_key)

			return status.sessionState
		end

		# *****************************************************************
		# URLs
		# *****************************************************************

		#
		# Success URL for this command
		#
		attr_accessor :success_url

		#
		# Failed URL for this command
		#
		attr_accessor :failed_url

	protected

		#
		# Get configured communicator
		#
		def communicator
			@communicator = GopayCommunicator.new(Config.ws_url) if @communicator.nil?
			return @communicator
		end

	end
end
