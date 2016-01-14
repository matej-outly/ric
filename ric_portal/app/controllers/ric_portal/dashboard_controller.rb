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

require_dependency "ric_portal/application_controller"

module RicPortal
	class DashboardController < ApplicationController
		include RicPortal::Concerns::Controllers::DashboardController
	end
end
