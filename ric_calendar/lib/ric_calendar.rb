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
require 'ric_calendar/concerns/models/event'
require 'ric_calendar/concerns/models/colored'
require 'ric_calendar/concerns/models/calendar'
require 'ric_calendar/concerns/models/schedulable'
require 'ric_calendar/concerns/models/recurring'
require 'ric_calendar/concerns/models/validity'

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
	# Event model
	#
	mattr_accessor :event_model
	def self.event_model
		return @@event_model.constantize
	end
	@@event_model = "RicCalendar::Event"

	#
	# Calendar model
	#
	mattr_accessor :calendar_model
	def self.calendar_model
		return @@calendar_model.constantize
	end
	@@calendar_model = "RicCalendar::Calendar"

end
