# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Teams
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_league/admin_controller"

module RicLeague
	class AdminTeamsController < AdminController
		include RicLeague::Concerns::Controllers::Admin::TeamsController
	end
end

