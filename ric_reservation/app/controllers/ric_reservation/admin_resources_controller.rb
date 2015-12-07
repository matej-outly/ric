# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resources
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

require_dependency "ric_reservation/admin_controller"

module RicReservation
	class AdminResourcesController < AdminController
		include RicReservation::Concerns::Controllers::Admin::ResourcesController
	end
end