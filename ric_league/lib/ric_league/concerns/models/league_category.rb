# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League category
# *
# * Author: Matěj Outlý
# * Date  : 14. 1. 2016
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Models
			module LeagueCategory extend ActiveSupport::Concern

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
					has_many :league_matches, class_name: RicLeague.league_match_model.to_s, dependent: :nullify

					#
					# Relation to teams
					#
					has_many :team_members, class_name: RicLeague.team_member_model.to_s, dependent: :nullify

					#
					# Relation to teams
					#
					has_many :teams, class_name: RicLeague.team_model.to_s, dependent: :nullify

				end

				module ClassMethods
					
					

				end

			end
		end
	end
end