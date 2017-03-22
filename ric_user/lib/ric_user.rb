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

require "ric_user/concerns/models/user_person"
require "ric_user/concerns/models/user_role"

require "ric_user/concerns/models/user"
require "ric_user/concerns/models/multi_people_user"
require "ric_user/concerns/models/multi_roles_user"
require "ric_user/concerns/models/single_person_user"
require "ric_user/concerns/models/single_role_user"

require "ric_user/concerns/models/person"
require "ric_user/concerns/models/model_1_person"
require "ric_user/concerns/models/model_2_person"
require "ric_user/concerns/models/model_3_person"

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
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	@@mailer_sender = "no-reply@clockapp.cz"

	#
	# Roles
	#
	mattr_accessor :roles
	@@roles = ["admin"]

	#
	# Default role
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
	#
	mattr_accessor :user_person_association
	@@user_person_association = :one_user_one_person

	#
	# Person types
	#
	mattr_accessor :person_types
	@@person_types = []

end
