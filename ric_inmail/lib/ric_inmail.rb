# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicMagazine
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Engines
require "ric_inmail/engine"

# Models
require "ric_inmail/concerns/models/in_message"

module RicInmail

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
	# Message model
	#
	mattr_accessor :in_message_model
	def self.in_message_model
		return @@in_message_model.constantize
	end
	@@in_message_model = "RicInmail::InMessage"

	#
	# If set to true, current_user.person is used for message owner and sender resolving, otherwise just current_user is used
	#
	mattr_accessor :use_person
	@@use_person = false

end
