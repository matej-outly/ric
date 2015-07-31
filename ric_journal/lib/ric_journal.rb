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
	# Newie model
	#
	mattr_accessor :newie_model
	def self.newie_model
		if @@newie_model.nil?
			return RicJournal::Newie
		else
			return @@newie_model.constantize
		end
	end

	#
	# Event model
	#
	mattr_accessor :event_model
	def self.event_model
		if @@event_model.nil?
			return RicJournal::Event
		else
			return @@event_model.constantize
		end
	end

end
