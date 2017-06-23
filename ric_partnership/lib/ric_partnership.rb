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
require "ric_partnership/concerns/models/partner"

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
	# Localization of some specific columns (names, etc.) TODO not working right now
	#
	mattr_accessor :localization
	@@localization = false

	#
	# Cropping of partner logo
	#
	mattr_accessor :partner_logo_crop
	@@partner_logo_crop = {
		full: "300x300>"
	}

end
