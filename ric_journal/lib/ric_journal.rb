# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicJournal
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

# Engines
require "ric_journal/admin_engine"
require "ric_journal/public_engine"

# Models
require 'ric_journal/concerns/models/newie'
require 'ric_journal/concerns/models/newie_picture'
require 'ric_journal/concerns/models/event'

module RicJournal

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
	# Newie model
	#
	mattr_accessor :newie_model
	def self.newie_model
		return @@newie_model.constantize
	end
	@@newie_model = "RicJournal::Newie"

	#
	# Newie picture model
	#
	mattr_accessor :newie_picture_model
	def self.newie_picture_model
		return @@newie_picture_model.constantize
	end
	@@newie_picture_model = "RicJournal::NewiePicture"

	#
	# Event model
	#
	mattr_accessor :event_model
	def self.event_model
		return @@event_model.constantize
	end
	@@event_model = "RicJournal::Event"

end
