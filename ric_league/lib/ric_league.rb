# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicLeague
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Engines
require "ric_league/admin_engine"
require "ric_league/public_engine"

# Models
require 'ric_league/concerns/models/league_category'
require 'ric_league/concerns/models/league_season'
require 'ric_league/concerns/models/league_match'
require 'ric_league/concerns/models/team'
require 'ric_league/concerns/models/team_member'

module RicLeague

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
	# League category model
	#
	mattr_accessor :league_category_model
	def self.league_category_model
		return @@league_category_model.constantize
	end
	@@league_category_model = "RicLeague::LeagueCategory"

	#
	# League season model
	#
	mattr_accessor :league_season_model
	def self.league_season_model
		return @@league_season_model.constantize
	end
	@@league_season_model = "RicLeague::LeagueSeason"

	#
	# League match model
	#
	mattr_accessor :league_match_model
	def self.league_match_model
		return @@league_match_model.constantize
	end
	@@league_match_model = "RicLeague::LeagueMatch"

	#
	# Team model
	#
	mattr_accessor :team_model
	def self.team_model
		return @@team_model.constantize
	end
	@@team_model = "RicLeague::Team"

	#
	# Team member model
	#
	mattr_accessor :team_member_model
	def self.team_member_model
		return @@team_member_model.constantize
	end
	@@team_member_model = "RicLeague::TeamMember"

end
