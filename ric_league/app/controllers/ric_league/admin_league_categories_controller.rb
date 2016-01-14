# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League categories
# *
# * Author: Matěj Outlý
# * Date  : 14. 1. 2016
# *
# *****************************************************************************

require_dependency "ric_league/admin_controller"

module RicLeague
	class AdminLeagueCategoriesController < AdminController
		include RicLeague::Concerns::Controllers::Admin::LeagueCategoriesController
	end
end