# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

require_dependency "ric_reservation/admin_controller"

module RicReservation
	class AdminEventsController < AdminController
		include RicReservation::Concerns::Controllers::Admin::EventsController
	end
end