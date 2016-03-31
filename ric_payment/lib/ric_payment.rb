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
require "ric_payment/engine"

# Models
require 'ric_payment/concerns/model/payment_subject'


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
	# Payment subject model
	#
	mattr_accessor :payment_subject_model
	def self.payment_subject_model
		return @@payment_subject_model.constantize
	end
	@@payment_subject_model = "RicEshop::Order"

	#
	# Payment subject mailer
	#
	mattr_accessor :payment_subject_mailer
	def self.payment_subject_mailer
		return @@payment_subject_mailer.constantize
	end
	@@payment_subject_mailer = "RicEshop::OrderMailer"

end
