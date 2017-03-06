# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAuth
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Engines
require "ric_auth/admin_engine"
require "ric_auth/public_engine"

# Concerns
require "ric_auth/concerns/application_paths"
require "ric_auth/concerns/devise_paths"

module RicAuth

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
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		return @@user_model.constantize
	end
	@@user_model = "RicUser::User"

	#
	# Devise paths concern
	#
	mattr_accessor :devise_paths_concern
	def self.devise_paths_concern
		return @@devise_paths_concern.constantize
	end
	@@devise_paths_concern = "RicAuth::Concerns::DevisePaths"

	#
	# Public auth layout
	#
	mattr_accessor :public_auth_layout
	@@public_auth_layout = nil

	#
	# Admin auth layout
	#
	mattr_accessor :admin_auth_layout
	@@admin_auth_layout = "ruth_admin_auth"

end
