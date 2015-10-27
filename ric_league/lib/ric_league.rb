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
	# League season model
	#
	mattr_accessor :league_season_model
	def self.league_season_model
		if @@league_season_model.nil?
			return RicLeague::LeagueSeason
		else
			return @@league_season_model.constantize
		end
	end

	#
	# League match model
	#
	mattr_accessor :league_match_model
	def self.league_match_model
		if @@league_match_model.nil?
			return RicLeague::LeagueMatch
		else
			return @@league_match_model.constantize
		end
	end

	#
	# Team model
	#
	mattr_accessor :team_model
	def self.team_model
		if @@team_model.nil?
			return RicLeague::Team
		else
			return @@team_model.constantize
		end
	end

	#
	# Team member model
	#
	mattr_accessor :team_member_model
	def self.team_member_model
		if @@team_member_model.nil?
			return RicLeague::TeamMember
		else
			return @@team_member_model.constantize
		end
	end

end
