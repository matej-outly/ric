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
require "ric_auth/engine"

# Concerns
require "ric_auth/concerns/application_paths"
require "ric_auth/concerns/devise_paths"
require "ric_auth/concerns/overrides"

# Models
require "ric_auth/concerns/models/authentication"
require "ric_auth/concerns/models/devisable"
require "ric_auth/concerns/models/omniauthable"
require "ric_auth/concerns/models/override"

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
	# Authentication model
	#
	mattr_accessor :authentication_model
	def self.authentication_model
		return @@authentication_model.constantize
	end
	@@authentication_model = "RicAuth::Authentication"

	#
	# Override model
	#
	mattr_accessor :override_model
	def self.override_model
		return @@override_model.constantize
	end
	@@override_model = "RicAuth::Override"

	#
	# Devise paths concern
	#
	mattr_accessor :devise_paths_concern
	def self.devise_paths_concern
		return @@devise_paths_concern.constantize
	end
	@@devise_paths_concern = "RicAuth::Concerns::DevisePaths"

	#
	# Use devise for basic authentication
	#
	mattr_accessor :use_devise
	@@use_devise = true

	#
	# Use omniauth for authentication
	#
	mattr_accessor :use_omniauth
	@@use_omniauth = false

	#
	# Special layout
	#
	mattr_accessor :layout
	@@layout = nil

	#
	# Use the following devise features
	#
	mattr_accessor :devise_features
	@@devise_features = [
		:database_authenticatable,
		:recoverable,
		:rememberable,
		:trackable,
		:validatable,
		# :registerable,
		# :confirmable,
		# :lockable,
		# :timeoutable,
	]

end
