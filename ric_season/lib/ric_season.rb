# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicSeason
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

# Engines
require "ric_season/admin_engine"
require "ric_season/public_engine"

# Models
require 'ric_season/concerns/models/season'

module RicSeason

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
	# Season model
	#
	mattr_accessor :season_model
	def self.season_model
		return @@season_model.constantize
	end
	@@season_model = "RicSeason::Season"

end
