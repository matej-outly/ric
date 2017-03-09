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
	class EventsController < ApplicationController
		include RicCalendar::Concerns::Controllers::EventsController
		include RicCalendar::Concerns::Controllers::UpdateScheduleAction
	end
end