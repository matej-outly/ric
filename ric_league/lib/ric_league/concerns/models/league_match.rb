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

					# *************************************************************************
					# Validators
					# *************************************************************************

					validates_presence_of :team1_id, :team2_id

				end

				module ClassMethods

					# *************************************************************************
					# Scopes
					# *************************************************************************

					def already_played
						now = Time.current
						where("played_at <= :now", now: now)
					end

				end

				# *************************************************************************
				# Virtual attributes
				# *************************************************************************

				def teams
					return (self.team1 && self.team1.key ? self.team1.key.upcase : "") + config(:teams_delimiter) + (self.team2 && self.team2.key ? self.team2.key.upcase : "")
				end

				def result
					return self.result1.to_s + config(:result_delimiter) + self.result2.to_s
				end

			end
		end
	end
end