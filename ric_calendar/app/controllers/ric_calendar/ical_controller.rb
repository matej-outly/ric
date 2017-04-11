# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_calendar/application_controller"

module RicCalendar
	class IcalController < ApplicationController
		include RicCalendar::Concerns::Controllers::IcalController
	end
end