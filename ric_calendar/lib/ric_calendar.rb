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
require "ric_calendar/concerns/models/event"
require "ric_calendar/concerns/models/colored"
require "ric_calendar/concerns/models/calendar"
require "ric_calendar/concerns/models/schedulable"
require "ric_calendar/concerns/models/recurring"
require "ric_calendar/concerns/models/validity"

# Sources
require "ric_calendar/sources/holiday_api"

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

	#
	# Predefined calendar kinds with types and URL definitions
	#
	mattr_accessor :calendar_kinds
	@@calendar_kinds = {
		simple: {
			resource_type: "RicCalendar::Calendar",
			resource_to_events_attr: :events,
			event_type: "RicCalendar::Event",
			event_to_resource_attr: :calendar,
			event_show_path: "ric_calendar.event_path",
			event_update_path: "ric_calendar.event_path",
		},
#		sample_model: {
#			resource_type: "SampleResource",
#			resource_to_events_attr: :sample_events,
#			event_type: "SampleEvents",
#			event_to_resource_attr: :sample_resource,
#			event_show_path: "main_app.sample_event_path",
#			event_update_path: "main_app.update_schedule_sample_event_path",
#		},
#		sample_api: {
#			source: "RicCalendar::Sources::SampleApi",
#			resource_type: "RicCalendar::Calendar",
#			resource_to_events_attr: :events,
#			event_type: "RicCalendar::Event",
#			event_to_resource_attr: :calendar,
#			event_show_path: "ric_calendar.event_path",
#			event_update_path: "ric_calendar.event_path",
#		}
	}

	#
	# Predefined colors
	#
	mattr_accessor :colors
	@@colors = {
		yellow: {
			primary: "#fff178",
			faded: "#faf3b7",
			text: "black",
		},
		turquoise: {
			primary: "#71e8ac",
			faded: "#b5eed1",
			text: "white",
		},
		blue: {
			primary: "#a2e1f1",
			faded: "#ceeff7",
			text: "black",
		},
		pink: {
			primary: "#ff79a9",
			faded: "#fda8c6",
			text: "white",
		},
		violet: {
			primary: "#bdb0ff",
			faded: "#d7d0f6",
			text: "white",
		},
		orange: {
			primary: "#f89d7a",
			faded: "#f4baa4",
			text: "white",
		},
		red: {
			primary: "#fa7c7c",
			faded: "#f9b8b8",
			text: "white",
		},
		green: {
			primary: "#c2f39a",
			faded: "#e0f7cd",
			text: "black",
		},
		grey: {
			primary: "#eeeeee",
			faded: "#eeeeee",
			text: "black",
		},
	}

end
