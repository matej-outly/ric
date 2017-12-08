# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicMailboxer
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Engines
require "ric_mailboxer/engine"

# Models
require "ric_mailboxer/concerns/models/messageable"
require "ric_mailboxer/concerns/models/conversation"

module RicMailboxer
	
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
	# Contact message model
	#
	mattr_accessor :conversation_model
	def self.conversation_model
		return @@conversation_model.constantize
	end
	@@conversation_model = "RicMailboxer::Conversation"

	#
	# If set to true, current_user.person is used for message owner and sender resolving, otherwise just current_user is used
	#
	mattr_accessor :use_person
	@@use_person = false

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
