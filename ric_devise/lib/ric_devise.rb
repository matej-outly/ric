# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicDevise
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Devise
require 'devise'

# Engines
require "ric_devise/engine"

module RicDevise

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

end
