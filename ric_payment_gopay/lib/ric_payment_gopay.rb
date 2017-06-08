# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPaymentGopay
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Railtie
require "ric_payment_gopay/railtie" if defined?(Rails)

# Engines
require "ric_payment_gopay/gateway_engine"
require "ric_payment_gopay/public_engine"

# Backend
require "ric_payment_gopay/backend"

# Helpers
require "ric_payment_gopay/helpers/merchant_helper"

module RicPaymentGopay

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
	# ID of your account in the GoPay system.
	#
	mattr_accessor :go_id
	@@go_id = 1

	#
	# ID of test account in the GoPay system.
	#
	mattr_accessor :test_go_id
	@@test_go_id = 1

	#
	# Secure key.
	#
	mattr_accessor :secure_key
	@@secure_key = "..."

	#
	# Test secure key.
	#
	mattr_accessor :test_secure_key
	@@test_secure_key = "..."

	#
	# Gateway language.
	#
	mattr_accessor :language
	@@language = "CS"

	#
	# ID of your account in the GoPay system.
	#
	mattr_accessor :allowed_channels
	@@allowed_payment_channels = [ "eu_gp_u", "eu_bank" ]

	#
	# Default currency used if not specified in payment subject.
	#
	mattr_accessor :default_currency
	@@default_currency = "CZK"
	
end
