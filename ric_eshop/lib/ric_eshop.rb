# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicEshop
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

require "ric_eshop/engine"

module RicEshop

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Order model
	#
	mattr_accessor :order_model
	def self.order_model
		if @@order_model.nil?
			return RicEshop::Order
		else
			return @@order_model.constantize
		end
	end

end
