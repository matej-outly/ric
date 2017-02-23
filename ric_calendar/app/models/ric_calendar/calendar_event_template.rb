# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document folder model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	class CalendarEventTemplate < ActiveRecord::Base
		include RicCalendar::Concerns::Models::CalendarEventTemplate
	end
end