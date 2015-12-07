# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resource
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicReservation
	class Resource < ActiveRecord::Base
		include RicReservation::Concerns::Models::Resource
	end
end