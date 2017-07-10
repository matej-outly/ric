# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicException
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

# Engines
require "ric_exception/engine"

# Mailers
require "ric_exception/concerns/mailers/exception_mailer"

module RicException

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
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	#@@mailer_sender = ... to be set in module initializer

	#
	# Mailer receiver
	#
	mattr_accessor :mailer_receiver
	#@@mailer_receiver = ... to be set in module initializer

	#
	# Special layout
	#
	mattr_accessor :layout
	@@layout = nil
	
end
