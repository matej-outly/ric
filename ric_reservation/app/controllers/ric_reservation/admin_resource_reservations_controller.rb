# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resource reservations
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

require_dependency "ric_reservation/admin_controller"

module RicReservation
	class AdminResourceReservationsController < AdminController
		include RicReservation::Concerns::Controllers::Admin::ResourceReservationsController
	end
end