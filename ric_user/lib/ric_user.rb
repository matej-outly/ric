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
require "ric_user/concerns/models/person"
require "ric_user/concerns/models/person_with_multiple_users"
require "ric_user/concerns/models/session"
require "ric_user/concerns/models/user"

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

end
