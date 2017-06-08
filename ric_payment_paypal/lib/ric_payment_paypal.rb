# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPaymentPaypal
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Railtie
require "ric_payment_paypal/railtie" if defined?(Rails)

# Engines
require "ric_payment_paypal/gateway_engine"
require "ric_payment_paypal/public_engine"

# Backend
require "ric_payment_paypal/backend"

module RicPaymentPaypal

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Use for switch between development and production environment.
	#
	mattr_accessor :environment
	@@environment = "development"

	#
	# Client ID in the PayPal system.
	#
	mattr_accessor :client_id
	@@client_id = nil

	#
	# Testb client ID in the PayPal system.
	#
	mattr_accessor :test_client_id
	@@test_client_id = nil

	#
	# Secret.
	#
	mattr_accessor :client_secret
	@@client_secret = nil

	#
	# Test secret.
	#
	mattr_accessor :test_client_secret
	@@test_client_secret = nil

	#
	# Default currency used if not specified in payment subject.
	#
	mattr_accessor :default_currency
	@@default_currency = "CZK"
	
end
