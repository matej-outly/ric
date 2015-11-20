# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Ladders ticker
# *
# * Author: Matěj Outlý
# * Date  : 20. 11. 2015
# *
# *****************************************************************************

class RicLeague::ActiveLeagueLaddersTickerComponent < RugController::Component

	def control
		@league_seasons = RicLeague.league_season_model.where(active: true).order(started_at: :desc)
		@league_ladders = []
		@league_seasons.each do |league_season|
			@league_ladders << RicLeague.team_model.league_ladder(league_season)
		end
	end

end