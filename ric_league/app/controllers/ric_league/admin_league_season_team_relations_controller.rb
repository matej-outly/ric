# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League season team relations
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_league/admin_controller"

module RicLeague
	class AdminLeagueSeasonTeamRelationsController < AdminController
		include RicLeague::Concerns::Controllers::Admin::LeagueSeasonTeamRelationsController
	end
end