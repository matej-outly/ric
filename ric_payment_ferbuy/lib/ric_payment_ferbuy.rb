# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPaymentFerbuy
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

# Engines
require "ric_payment_ferbuy/admin_engine"
require "ric_payment_ferbuy/public_engine"

# Backend
require 'ric_payment_ferbuy/backend'
	
module RicPaymentFerbuy

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
	# URL where the FerBuy gate is located.
	#
	mattr_accessor :gate_url
	@@gate_url = "https://gateway.ferbuy.com/live/"

	#
	# URL where the FerBuy test gate is located.
	#
	mattr_accessor :test_gate_url
	@@test_gate_url = "https://gateway.ferbuy.com/demo/"

	#
	# URL where the FerBuy API is located.
	#
	mattr_accessor :api_url
	@@api_url = "https://gateway.ferbuy.com/api/"

	#
	# ID of your site in the FerBuy system.
	#
	mattr_accessor :site_id
	@@site_id = 1

	#
	# Password for external communication that you can fill in for the account.
	# This password should not be the same that you use to log-in to the 
	# administration.
	#
	mattr_accessor :secret
	@@secret = "my$up3rsecr3tp4$$word"
	
	#
	# Default currency used if not specified in payment subject.
	#
	mattr_accessor :default_currency
	@@default_currency = "CZK"

	#
	# Default language used if not specified in payment subject.
	#
	mattr_accessor :default_language
	@@default_language = "cs"	

end
