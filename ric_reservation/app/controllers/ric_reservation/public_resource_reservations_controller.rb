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

require_dependency "ric_reservation/public_controller"

module RicReservation
	class PublicResourceReservationsController < PublicController
		include RicReservation::Concerns::Controllers::Public::ResourceReservationsController
	end
end