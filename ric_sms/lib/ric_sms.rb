# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Ric SMS
# *
# * Author: Matěj Outlý
# * Date  : 1. 12. 2017
# *
# *****************************************************************************

# Engines
require "ric_sms/engine"

# Providers
require "ric_sms/plivo/provider"
require "ric_sms/text_magic/provider"

module RicSms

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
	# Interface
	# *************************************************************************

	def self.provider_obj
		if @provider_obj.nil?
			provider_class_name = "RicSms::#{RicSms.provider.to_s.to_camel}::Provider"
			@provider_obj = provider_class_name.constantize.new(RicSms.provider_params)
		end
		return @provider_obj
	end

	def self.deliver(receiver, message)
		self.provider_obj.deliver(receiver, message)
		return nil
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Used provider
	#
	mattr_accessor :provider
	@@provider = "plivo"

	#
	# Provider params
	#
	mattr_accessor :provider_params
	@@provider_params = {}

	#
	# Sender
	#
	mattr_accessor :sender
	@@sender = nil

end
