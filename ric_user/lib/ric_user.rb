# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicUser
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Engine
require "ric_user/engine"

# Models
require "ric_user/concerns/models/session"
require "ric_user/concerns/models/role"
require "ric_user/concerns/models/user_role"
require "ric_user/concerns/models/user"
require "ric_user/concerns/models/user/multi_dynamic_roles"
require "ric_user/concerns/models/user/multi_static_roles"
require "ric_user/concerns/models/user/single_static_role"
require "ric_user/concerns/models/user/single_dynamic_role"

# Mailers
require "ric_user/concerns/mailers/user_mailer"

module RicUser

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
	# Role model
	#
	mattr_accessor :role_model
	def self.role_model
		return @@role_model.constantize
	end
	@@role_model = "RicUser::Role"

	#
	# User role model
	#
	mattr_accessor :user_role_model
	def self.user_role_model
		return @@user_role_model.constantize
	end
	@@user_role_model = "RicUser::UserRole"

	#
	# User role person model
	#
	mattr_accessor :user_role_person_model
	def self.user_role_person_model
		return @@user_role_person_model.constantize
	end
	@@user_role_person_model = nil

	#
	# User mailer
	#
	mattr_accessor :user_mailer
	def self.user_mailer
		return @@user_mailer.constantize
	end
	@@user_mailer = "RicUser::UserMailer"

	#
	# Session model
	#
	mattr_accessor :session_model
	def self.session_model
		return @@session_model.constantize
	end
	@@session_model = "RicUser::Session"

	#
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	@@mailer_sender = "no-reply@clockapp.cz"

	#
	# Association between users and roles
	#
	# Available values:
	# - none
	# - user_belongs_to_role
	# - user_has_and_belongs_to_many_roles
	#
	mattr_accessor :user_role_association
	@@user_role_association = :user_belongs_to_role

	#
	# Use roles hard-coded in configuration
	#
	mattr_accessor :use_static_roles
	@@use_static_roles = true

	#
	# Available static roles (used only if use_static_roles set to true)
	#
	mattr_accessor :roles
	@@roles = ["admin"]

	#
	# Role set as default after user created (used only if use_static_roles set to true)
	#
	mattr_accessor :default_role
	@@default_role = nil

	#
	# Scope UserRole model by person. If true, user_role_person_model must be defined
	#
	mattr_accessor :scope_user_role_by_person
	@@scope_user_role_by_person = false

	#
	# Include name to user model?
	#
	mattr_accessor :user_name
	@@user_name = false

	#
	# Include avatar to user model?
	#
	mattr_accessor :user_avatar
	@@user_avatar = false

	#
	# Is user avatar croppable?
	#
	mattr_accessor :user_avatar_croppable
	@@user_avatar_croppable = false

	#
	# User avatar crop styles
	#
	mattr_accessor :user_avatar_crop
	@@user_avatar_crop = {
		thumb: "200x200#",
		full: "500x500#"
	}

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
