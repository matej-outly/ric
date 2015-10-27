# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Teams
# *
# * Author: Matěj Outlý
# * Date  : 13. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_league/public_controller"

module RicLeague
	class PublicTeamsController < PublicController
		include RicLeague::Concerns::Controllers::Public::TeamsController
	end
end
