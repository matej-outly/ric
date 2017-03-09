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
	class Event < ActiveRecord::Base
		include RicCalendar::Concerns::Models::Schedulable
		include RicCalendar::Concerns::Models::Recurring

		include RicCalendar::Concerns::Models::Event
	end
end