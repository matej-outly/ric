# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document Folders
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_calendar/calendar_controller"

module RicCalendar
	class CalendarController < ApplicationController
		include RicCalendar::Concerns::Controllers::CalendarController
	end
end