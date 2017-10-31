# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicStaging
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

# Engines
require "ric_staging/engine"

# Models
require "ric_staging/concerns/models/stage"
require "ric_staging/concerns/models/stagable"

module RicStaging

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
	# Stage model
	#
	mattr_accessor :stage_model
	def self.stage_model
		return @@stage_model.constantize
	end
	@@stage_model = "RicStaging::Stage"

end
