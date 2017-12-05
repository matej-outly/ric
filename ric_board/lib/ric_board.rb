# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicBoard
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

# Railtie
require "ric_board/railtie" if defined?(Rails)

# Engines
require "ric_board/engine"

# Models
require "ric_board/concerns/models/board_ticket"
require "ric_board/concerns/models/ticketable"

# Helpers
require "ric_board/helpers/board_helper"

module RicBoard

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
	# Board Ticket model
	#
	mattr_accessor :board_ticket_model
	def self.board_ticket_model
		return @@board_ticket_model.constantize
	end
	@@board_ticket_model = "RicBoard::BoardTicket"

	#
	# Dashboard layout
	#
	mattr_accessor :layout
	@@layout = {
		jumbotron: {
			width: 12
		},
		panels: {
			width: 8,
			columns: 2
		},
		tickets: {
			width: 4,
			columns: 1
		}
	}

	#
	# Definition of board panels
	#
	# board_panels = {
	#	key_1: {
	#		show_if: "Sample.authorize(user: current_user, action: :load)"
	#	}
	# }
	#
	mattr_accessor :board_panels
	@@board_panels = {}

	#
	# Definition of types (models) usable as subject
	#
	# board_ticket_types = {
	#	key_1: {
	#		template: "default",
	#		color: "red",
	#		title: "headers.dashboard.key_1",
	# 		priority: 99,
	#		followable: true,
	#	}
	#}
	#
	mattr_accessor :board_ticket_types
	@@board_ticket_types = {}
	
	def self.board_ticket_type(key)
		if @@board_ticket_types.include?(key.to_sym)
			return {
				template: "default",
				color: "blue",
				title: nil,
				priority: 0,
				key: key.to_s,
			}.merge(@@board_ticket_types[key.to_sym])
		else
			raise "Key `#{key}` not found in RicBoard.board_ticket_types configuration."
		end
	end
	
	#
	# Enable groupping by subject types
	#
	mattr_accessor :group_board_tickets
	@@group_board_tickets = true

	#
	# If set to true, current_user.person is used for ticket owner resolving, otherwise just current_user is used
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
