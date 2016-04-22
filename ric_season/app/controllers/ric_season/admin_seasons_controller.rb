# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Seasons
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

require_dependency "ric_season/admin_controller"

module RicSeason
	class AdminSeasonsController < AdminController
		include RicSeason::Concerns::Controllers::Admin::SeasonsController
	end
end

