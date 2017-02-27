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

require_dependency "ric_calendar/application_controller"

module RicCalendar
	class CalendarEventsController < ApplicationController
		include RicCalendar::Concerns::Controllers::CalendarEventsController
	end
end