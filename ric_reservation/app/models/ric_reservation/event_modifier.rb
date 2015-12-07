# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event modifier
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicReservation
	class EventModifier < ActiveRecord::Base
		include RicReservation::Concerns::Models::EventModifier
	end
end