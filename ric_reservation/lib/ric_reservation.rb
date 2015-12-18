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

# Engines
require "ric_reservation/admin_engine"
require "ric_reservation/public_engine"

# Models
require 'ric_reservation/concerns/models/resource'
require 'ric_reservation/concerns/models/event'
require 'ric_reservation/concerns/models/event_modifier'
require 'ric_reservation/concerns/models/reservation'
require 'ric_reservation/concerns/models/event_reservation'
require 'ric_reservation/concerns/models/resource_reservation'

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
	# Resource model
	#
	mattr_accessor :resource_model
	def self.resource_model
		if @@resource_model.nil?
			return RicReservation::Resource
		else
			return @@resource_model.constantize
		end
	end

	#
	# Event model
	#
	mattr_accessor :event_model
	def self.event_model
		if @@event_model.nil?
			return RicReservation::Event
		else
			return @@event_model.constantize
		end
	end

	#
	# Event modifier model
	#
	mattr_accessor :event_modifier_model
	def self.event_modifier_model
		if @@event_modifier_model.nil?
			return RicReservation::EventModifier
		else
			return @@event_modifier_model.constantize
		end
	end

	#
	# Reservation model
	#
	mattr_accessor :reservation_model
	def self.reservation_model
		if @@reservation_model.nil?
			return RicReservation::Reservation
		else
			return @@reservation_model.constantize
		end
	end

	#
	# Owner model
	#
	mattr_accessor :owner_model
	def self.owner_model
		if @@owner_model.nil?
			return RicUser::User
		else
			return @@owner_model.constantize
		end
	end

end
