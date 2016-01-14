# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Timetables
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

require_dependency "ric_reservation/public_controller"

module RicReservation
	class PublicTimetablesController < PublicController
		include RicReservation::Concerns::Controllers::Public::TimetablesController
	end
end