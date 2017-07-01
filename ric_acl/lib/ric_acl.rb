# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAcl
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

# Railtie
require "ric_acl/railtie" if defined?(Rails)

# Engines
require "ric_acl/engine"

# Models
require "ric_acl/concerns/models/privilege"

# Module concerns
require "ric_acl/concerns/authorization"

module RicAcl

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Concerns
	# *************************************************************************	

	include RicAcl::Concerns::Authorization

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
	# Privilege model
	#
	mattr_accessor :privilege_model
	def self.privilege_model
		return @@privilege_model.constantize
	end
	@@privilege_model = "RicAcl::Privilege"

end
