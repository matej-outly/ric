# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	class Engine < ::Rails::Engine

		#
		# Controllers
		#
		require 'ric_calendar/concerns/controllers/calendars_controller'
		require 'ric_calendar/concerns/controllers/events_controller'
		require 'ric_calendar/concerns/controllers/ical_controller'

		#
		# Authorization
		#
		require 'ric_calendar/concerns/authorization'

		isolate_namespace RicCalendar

	end
end
