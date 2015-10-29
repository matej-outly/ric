# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League matches
# *
# * Author: Matěj Outlý
# * Date  : 29. 10. 2015
# *
# *****************************************************************************

require_dependency "ric_league/admin_controller"

module RicLeague
	class AdminLeagueMatchesController < AdminController
		include RicLeague::Concerns::Controllers::Admin::LeagueMatchesController
	end
end