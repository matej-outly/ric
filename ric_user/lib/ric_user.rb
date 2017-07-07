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

# Engines
require "ric_user/admin_engine"
require "ric_user/public_engine"

# Models
require "ric_user/concerns/models/session"

require "ric_user/concerns/models/role"

require "ric_user/concerns/models/user_person"
require "ric_user/concerns/models/user_role"

require "ric_user/concerns/models/user"
require "ric_user/concerns/models/user/multi_dynamic_roles"
require "ric_user/concerns/models/user/multi_people"
require "ric_user/concerns/models/user/multi_static_roles"
require "ric_user/concerns/models/user/single_static_role"
require "ric_user/concerns/models/user/single_person"
require "ric_user/concerns/models/user/single_dynamic_role"

require "ric_user/concerns/models/person"
require "ric_user/concerns/models/person/model_1"
require "ric_user/concerns/models/person/model_2"
require "ric_user/concerns/models/person/model_3"
require "ric_user/concerns/models/person/model_4"

require "ric_user/concerns/models/people_selector"
require "ric_user/concerns/models/people_selectable"

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
	# User person model
	#
	mattr_accessor :user_person_model
	def self.user_person_model
		return @@user_person_model.constantize
	end
	@@user_person_model = "RicUser::UserPerson"

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
	# People Selector model
	#
	mattr_accessor :people_selector_model
	def self.people_selector_model
		return @@people_selector_model.constantize
	end
	@@people_selector_model = "RicUser::PeopleSelector"

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
	# Association between users and people
	#
	# Available values:
	# - none
	# - one_user_one_person (model_1)
	# - one_user_many_people (model_2)
	# - many_users_one_person (model_3)
	# - many_users_many_people (model_4)
	#
	mattr_accessor :user_person_association
	@@user_person_association = :none

	#
	# Available person types
	#
	mattr_accessor :person_types
	@@person_types = []

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

end
