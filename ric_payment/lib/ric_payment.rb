# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPayment
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Engines
require "ric_payment/admin_engine"
require "ric_payment/public_engine"
require "ric_payment/gateway_engine"

# Models
require 'ric_payment/concerns/model/payment_subject'

# Backends
require 'ric_payment/backends/dummy_api'

module RicPayment

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
	# Backend
	#
	mattr_accessor :backend
	def self.backend
		return @@backend.constantize
	end
	@@backend = "RicPayment::Backends::DummyAPI"

	#
	# Payment model
	#
	mattr_accessor :payment_subject_model
	def self.payment_subject_model
		return @@payment_subject_model.constantize
	end
	@@payment_subject_model = "RicEshop::Order"

end
