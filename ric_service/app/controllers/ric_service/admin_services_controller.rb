# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Services
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

require_dependency "ric_service/admin_controller"

module RicService
	class AdminServicesController < AdminController
		include RicService::Concerns::Controllers::Admin::ServicesController
	end
end

