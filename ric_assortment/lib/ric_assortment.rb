# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicAssortment
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Engines
require "ric_assortment/admin_engine"
require "ric_assortment/public_engine"

# Models
require 'ric_assortment/concerns/models/product'

module RicAssortment

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Product model
	#
	mattr_accessor :product_model
	def self.product_model
		if @@product_model.nil?
			return RicAssortment::Product
		else
			return @@product_model.constantize
		end
	end

	#
	# Product category model
	#
	mattr_accessor :product_category_model
	def self.product_category_model
		if @@product_category_model.nil?
			return RicAssortment::ProductCategory
		else
			return @@product_category_model.constantize
		end
	end

end
