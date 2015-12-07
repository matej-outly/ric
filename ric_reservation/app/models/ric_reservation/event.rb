# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicReservation
	class Event < ActiveRecord::Base
		include RicReservation::Concerns::Models::Event
	end
end