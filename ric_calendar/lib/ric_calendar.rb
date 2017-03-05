# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# *
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

# Engines
require "ric_calendar/engine"

# Models
require 'ric_calendar/concerns/models/calendar_event'
require 'ric_calendar/concerns/models/calendar'
require 'ric_calendar/concerns/models/schedulable'
require 'ric_calendar/concerns/models/recurring'

# Controller concerns
require 'ric_calendar/concerns/controllers/update_schedule_action'

module RicCalendar

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# CalendarEvent model
	#
	mattr_accessor :calendar_event_model
	def self.calendar_event_model
		return @@calendar_event_model.constantize
	end
	@@calendar_event_model = "RicCalendar::CalendarEvent"

	#
	# Calendar model
	#
	mattr_accessor :calendar_model
	def self.calendar_model
		return @@calendar_model.constantize
	end
	@@calendar_model = "RicCalendar::Calendar"

end
