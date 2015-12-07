# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Reservation
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicReservation
	class Reservation < ActiveRecord::Base
		include RicReservation::Concerns::Models::Reservation
	end
end