# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Active league
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_league/public_controller"

module RicLeague
	class PublicActiveLeagueController < PublicController
		include RicLeague::Concerns::Controllers::Public::ActiveLeagueController
	end
end