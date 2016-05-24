# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Dashboard
# *
# * Author: Matěj Outlý
# * Date  : 24. 9. 2015
# *
# *****************************************************************************

require_dependency "ric_admin/application_controller"

module RicAdmin
	class DashboardController < ApplicationController
		include RicAdmin::Concerns::Controllers::DashboardController
	end
end
