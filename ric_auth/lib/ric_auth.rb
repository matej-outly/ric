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
require "ric_auth/concerns/overrides_user"
require "ric_auth/concerns/overrides_both"
require "ric_auth/concerns/password_enforcement"

# Models
require "ric_auth/concerns/models/authentication"
require "ric_auth/concerns/models/devisable"
require "ric_auth/concerns/models/omniauthable"
require "ric_auth/concerns/models/override_user"
require "ric_auth/concerns/models/override_both"

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
	# Store location for redirect after sign in/out/up
	#
	mattr_accessor :store_location_for_redirect
	@@store_location_for_redirect = true

	#
	# Redirect after sign in?
	#
	mattr_accessor :redirect_to_stored_location_after_sign_in
	@@redirect_to_stored_location_after_sign_in = true

	#
	# Redirect after sign out?
	#
	mattr_accessor :redirect_to_stored_location_after_sign_out
	@@redirect_to_stored_location_after_sign_out = false

	#
	# Redirect after sign up?
	#
	mattr_accessor :redirect_to_stored_location_after_sign_up
	@@redirect_to_stored_location_after_sign_up = false

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

	#
	# Authenticate token on sign in
	#
	mattr_accessor :authenticate_token
	@@authenticate_token = true

end
