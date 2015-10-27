# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League match
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Models
			module LeagueMatch extend ActiveSupport::Concern

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
					# Relation to league seasons
					#
					belongs_to :league_season, class_name: RicLeague.league_season_model.to_s

					#
					# Relation to teams
					#
					belongs_to :team1, class_name: RicLeague.team_model.to_s

					#
					# Relation to teams
					#
					belongs_to :team2, class_name: RicLeague.team_model.to_s

				end

			end
		end
	end
end