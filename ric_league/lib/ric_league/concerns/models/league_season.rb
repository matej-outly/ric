# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League season
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Models
			module LeagueSeason extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# Relation to league matches
					#
					has_many :league_matches, class_name: RicLeague.league_match_model.to_s, dependent: :destroy

					#
					# Relation to teams
					#
					has_and_belongs_to_many :teams, class_name: RicLeague.team_model.to_s

				end

				module ClassMethods
					
					# *********************************************************************
					# Scopes
					# *********************************************************************

					#
					# Get current season
					#
					def current
						return RicLeague.league_season_model.order(started_at: :desc).first
					end

				end

			end
		end
	end
end