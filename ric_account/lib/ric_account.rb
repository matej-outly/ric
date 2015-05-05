# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAccount
# *
# * Author: Matěj Outlý
# * Date  : 5. 5. 2015
# *
# *****************************************************************************

require "ric_account/engine"

module RicAccount

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
			return User
		else
			return @@user_model.constantize
		end
	end

end
