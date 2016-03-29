# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPartnership
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Engines
require "ric_partnership/admin_engine"
require "ric_partnership/public_engine"

# Models
require 'ric_partnership/concerns/models/partner'
require 'ric_partnership/concerns/models/reference'

module RicPartnership

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
	# Partner model
	#
	mattr_accessor :partner_model
	def self.partner_model
		return @@partner_model.constantize
	end
	@@partner_model = "RicPartnership::Partner"

	#
	# Enable partners subsystem
	#
	mattr_accessor :enable_partners
	@@enable_partners = true

	#
	# Reference model
	#
	mattr_accessor :reference_model
	def self.reference_model
		return @@reference_model.constantize
	end
	@@reference_model = "RicPartnership::Reference"

	#
	# Enable references subsystem
	#
	mattr_accessor :enable_references
	@@enable_references = true

end
