# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar Data model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	class CalendarData < ActiveRecord::Base
		include RicCalendar::Concerns::Models::CalendarData
	end
end