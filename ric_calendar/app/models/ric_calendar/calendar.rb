# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar
# *
# * Author: Jaroslav Mlejnek
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	class Calendar < ActiveRecord::Base
		include RicCalendar::Concerns::Models::Validity
		include RicCalendar::Concerns::Models::Colored
		include RicCalendar::Concerns::Models::Calendar
	end
end