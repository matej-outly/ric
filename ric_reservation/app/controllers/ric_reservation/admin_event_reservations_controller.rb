# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event reservations
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

require_dependency "ric_reservation/admin_controller"

module RicReservation
	class AdminEventReservationsController < AdminController
		include RicReservation::Concerns::Controllers::Admin::EventReservationsController
	end
end