# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicService
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

# Engines
require "ric_service/admin_engine"
require "ric_service/public_engine"

# Models
require "ric_service/concerns/models/service"

module RicService

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
	# Service model
	#
	mattr_accessor :service_model
	def self.service_model
		return @@service_model.constantize
	end
	@@service_model = "RicService::Service"

end
