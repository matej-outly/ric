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

# Models
require 'ric_user/concerns/models/user'

# Mailers
require 'ric_user/concerns/mailers/user_mailer'

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
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		if @@user_model.nil?
			return RicUser::User
		else
			return @@user_model.constantize
		end
	end

	#
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	def self.mailer_sender
		if @@mailer_sender.nil?
			return "no-reply@clockstar.cz"
		else
			return @@mailer_sender
		end
	end

end
