# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Team members
# *
# * Author: Matěj Outlý
# * Date  : 29. 10. 2015
# *
# *****************************************************************************

require_dependency "ric_league/admin_controller"

module RicLeague
	class AdminTeamMembersController < AdminController
		include RicLeague::Concerns::Controllers::Admin::TeamMembersController
	end
end
