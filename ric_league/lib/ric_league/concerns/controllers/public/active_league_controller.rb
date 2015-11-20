# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Active league
# *
# * Author: Matěj Outlý
# * Date  : 20. 11. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Public
				module ActiveLeagueController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team before some actions
						#
						before_action :set_league_seasons, only: [:schedule, :results]

					end

					#
					# Schedule action
					#
					def schedule
					end

					#
					# Results action
					#
					def results
					end

				protected

					def set_league_seasons
						@league_seasons = RicLeague.league_season_model.where(active: true).order(started_at: :desc)
					end

				end
			end
		end
	end
end
