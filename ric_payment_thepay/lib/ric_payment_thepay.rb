# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPaymentThepay
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Railtie
require "ric_payment_thepay/railtie" if defined?(Rails)

# Engines
require "ric_payment_thepay/gateway_engine"
require "ric_payment_thepay/public_engine"

# Backend
require "ric_payment_thepay/backend"

# Helpers
require "ric_payment_thepay/helpers/merchant_helper"

module RicPaymentThepay

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
	# URL where the ThePay gate is located.
	#
	mattr_accessor :gate_url
	@@gate_url = "https://www.thepay.cz/gate/"

	#
	# URL where the ThePay test gate is located.
	#
	mattr_accessor :test_gate_url
	@@test_gate_url = "https://www.thepay.cz/demo-gate/"

	#
	# ID of your account in the ThePay system.
	#
	mattr_accessor :merchant_id
	@@merchant_id = 1

	#
	# ID of test account in the ThePay system.
	#
	mattr_accessor :test_merchant_id
	@@test_merchant_id = 1

	#
	# ID of your account, which you can create in the ThePay administration 
	# interface. You can have multiple accounts under your login.
	#
	mattr_accessor :account_id
	@@account_id = 1

	#
	# ID of your account, which you can create in the ThePay administration 
	# interface. You can have multiple accounts under your login.
	#
	mattr_accessor :test_account_id
	@@test_account_id = 1

	#
	# Password for external communication that you can fill in for the account.
	# This password should not be the same that you use to log-in to the 
	# administration.
	#
	mattr_accessor :password
	@@password = "my$up3rsecr3tp4$$word"
	mattr_accessor :data_api_password
	@@data_api_password = "my$up3rsecr3tp4$$word"

	#
	# Password for external communication that you can fill in for the account.
	# This password should not be the same that you use to log-in to the 
	# administration.
	#
	mattr_accessor :test_password
	@@test_password = "my$up3rsecr3tp4$$word"
	mattr_accessor :test_data_api_password
	@@test_data_api_password = "my$up3rsecr3tp4$$word"

	#
	# URL of WSDL document for webservices API. Web services are used for 
	# automatic comunications with gate. For example for creating permanent 
	# payments.
	#
	mattr_accessor :web_services_wsdl
	@@web_services_wsdl = "https://www.thepay.cz/gate/api/gate-api.wsdl"
	mattr_accessor :data_web_services_wsdl
	@@data_web_services_wsdl = "https://www.thepay.cz/gate/api/data.wsdl"

	#
	# URL of WSDL document for webservices API. Web services are used for 
	# automatic comunications with gate. For example for creating permanent 
	# payments.
	#
	mattr_accessor :test_web_services_wsdl
	@@test_web_services_wsdl = "https://www.thepay.cz/demo-gate/api/gate-api-demo.wsdl"
	mattr_accessor :test_data_web_services_wsdl
	@@test_data_web_services_wsdl = "https://www.thepay.cz/demo-gate/api/data-demo.wsdl"

	#
	# Default currency used if not specified in payment subject.
	#
	mattr_accessor :default_currency
	@@default_currency = "CZK"

end
