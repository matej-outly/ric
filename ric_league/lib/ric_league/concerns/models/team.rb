# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Team
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Models
			module Team extend ActiveSupport::Concern

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
					# Relation to team members
					#
					has_many :team_members, class_name: RicLeague.team_member_model.to_s, dependent: :destroy

					#
					# Relation to league seasons
					#
					has_and_belongs_to_many :league_seasons, class_name: RicLeague.league_season_model.to_s

					#
					# Ordering
					#
					enable_ordering

				end

			end
		end
	end
end