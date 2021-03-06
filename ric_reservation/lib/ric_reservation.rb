# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicReservation
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Railtie
require "ric_reservation/railtie" if defined?(Rails)

# Engine
require "ric_reservation/engine"

# Models
require "ric_reservation/concerns/models/resource"
require "ric_reservation/concerns/models/event"
require "ric_reservation/concerns/models/reservation"
require "ric_reservation/concerns/models/event_reservation"
require "ric_reservation/concerns/models/resource_reservation"
require "ric_reservation/concerns/models/weekly_resource_event"

# Helpers
require "ric_reservation/helpers/month_timetable_helper"
require "ric_reservation/helpers/timetable_pagination_helper"
require "ric_reservation/helpers/week_timetable_helper"

module RicReservation

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
	# Resource model
	#
	mattr_accessor :resource_model
	def self.resource_model
		return @@resource_model.constantize
	end
	@@resource_model = "RicReservation::Resource"

	#
	# Event model
	#
	mattr_accessor :event_model
	def self.event_model
		return @@event_model.constantize
	end
	@@event_model = "RicReservation::Event"

	#
	# Event modifier model
	#
	mattr_accessor :event_modifier_model
	def self.event_modifier_model
		return @@event_modifier_model.constantize
	end
	@@event_modifier_model = "RicReservation::EventModifier"

	#
	# Reservation model
	#
	mattr_accessor :reservation_model
	def self.reservation_model
		return @@reservation_model.constantize
	end
	@@reservation_model = "RicReservation::Reservation"
	
	#
	# Class or object implementing actions_options, tabs_options, etc. can be set.
	#
	mattr_accessor :theme
	def self.theme
		if @@theme
			return @@theme.constantize if @@theme.is_a?(String)
			return @@theme
		end
		return OpenStruct.new
	end
	@@theme = nil
	
end
