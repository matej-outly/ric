# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Active teams
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_league/public_controller"

module RicLeague
	class PublicActiveTeamsController < PublicController
		include RicLeague::Concerns::Controllers::Public::ActiveTeamsController
	end
end