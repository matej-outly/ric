# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPartnership
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

# Engines
require "ric_partnership/admin_engine"
require "ric_partnership/public_engine"

# Models
require 'ric_partnership/concerns/models/partner'

module RicPartnership

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Partnership model
	#
	mattr_accessor :partner_model
	def self.partner_model
		if @@partner_model.nil?
			return RicPartnership::Partner
		else
			return @@partner_model.constantize
		end
	end

end
