# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPricing
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

# Engines
require "ric_pricing/admin_engine"
require "ric_pricing/public_engine"

# Models
require "ric_pricing/concerns/models/price_list"
require "ric_pricing/concerns/models/price"

module RicPricing

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
	# Price list model
	#
	mattr_accessor :price_list_model
	def self.price_list_model
		return @@price_list_model.constantize
	end
	@@price_list_model = "RicPricing::PriceList"

	#
	# Price model
	#
	mattr_accessor :price_model
	def self.price_model
		return @@price_model.constantize
	end
	@@price_model = "RicPricing::Price"

	#
	# Class or object implementing actions_options, tabs_options, etc. can be set.
	#
	mattr_accessor :theme
	def self.theme
		if @@theme
			return @@theme.constantize if @@theme.is_a?(String)
			return @@theme
		end
		return OpenStruct.new
	end
	@@theme = nil
	
end
