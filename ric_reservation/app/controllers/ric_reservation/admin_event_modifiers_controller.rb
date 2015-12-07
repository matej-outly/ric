# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event modifiers
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

require_dependency "ric_reservation/admin_controller"

module RicReservation
	class AdminEventModifiersController < AdminController
		include RicReservation::Concerns::Controllers::Admin::EventModifiersController
	end
end