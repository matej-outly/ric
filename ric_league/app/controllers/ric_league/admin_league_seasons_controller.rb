# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League seasons
# *
# * Author: Matěj Outlý
# * Date  : 29. 10. 2015
# *
# *****************************************************************************

require_dependency "ric_league/admin_controller"

module RicLeague
	class AdminLeagueSeasonsController < AdminController
		include RicLeague::Concerns::Controllers::Admin::LeagueSeasonsController
	end
end