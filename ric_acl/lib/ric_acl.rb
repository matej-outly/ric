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

# Helpers
require "ric_acl/helpers/authorization_helper"

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

	#
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		return @@user_model.constantize
	end
	@@user_model = "RicUser::User"

	#
	# Role model
	#
	mattr_accessor :role_model
	def self.role_model
		return @@role_model.constantize
	end
	@@role_model = "RicUser::Role"

	#
	# Use privileges hard-coded in configuration?
	#
	mattr_accessor :use_static_privileges
	@@use_static_privileges = false

	#
	# Defined privileges (used only if use_static_privileges set to true)
	#
	mattr_accessor :privileges
	@@privileges = [
#		{ role: "admin", subject_type: "Sample", action: :load },
#		{ role: "admin", subject_type: "Sample", action: :create },
#		{ role: "admin", subject_type: "Sample", action: :update },
#		{ role: "admin", subject_type: "Sample", action: :destroy },
	]

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
