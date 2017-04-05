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
require "ric_board/engine"

# Models
require 'ric_board/concerns/models/board_ticket'
require 'ric_board/concerns/models/boardable'

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

end
