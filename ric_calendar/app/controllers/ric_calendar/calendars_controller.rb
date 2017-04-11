# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendars
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_calendar/application_controller"

module RicCalendar
	class CalendarsController < ApplicationController
		include RicCalendar::Concerns::Controllers::CalendarsController
	end
end