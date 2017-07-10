# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicReference
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Engines
require "ric_reference/admin_engine"
require "ric_reference/public_engine"

# Models
require "ric_reference/concerns/models/reference"

module RicReference

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
	# Reference model
	#
	mattr_accessor :reference_model
	def self.reference_model
		return @@reference_model.constantize
	end
	@@reference_model = "RicReference::Reference"

	#
	# Localization of some specific columns (names, etc.) TODO not working right now
	#
	mattr_accessor :localization
	@@localization = false

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
