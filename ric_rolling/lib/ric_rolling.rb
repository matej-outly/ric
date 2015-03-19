# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicRolling
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

require "ric_rolling/engine"

module RicRolling

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
			return RicRolling::User
		else
			return @@user_model.constantize
		end
	end

	#
	# URL base
	#
	mattr_accessor :url_base

end
