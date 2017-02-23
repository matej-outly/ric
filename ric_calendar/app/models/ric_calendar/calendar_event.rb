# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	class CalendarEvent < ActiveRecord::Base
		include RicCalendar::Concerns::Models::CalendarEvent
	end
end