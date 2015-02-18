require "ric_customer/engine"

module RicCustomer

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Customer model
	#
	mattr_accessor :customer_model
	def self.customer_model
		if @@customer_model.nil?
			return RicCustomer::Customer
		else
			return @@customer_model.constantize
		end
	end

end
