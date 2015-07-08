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
require 'ric_assortment/concerns/models/product_attachment'
require 'ric_assortment/concerns/models/product_category'
require 'ric_assortment/concerns/models/product_photo'

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
	# Product attachment model
	#
	mattr_accessor :product_attachment_model
	def self.product_attachment_model
		if @@product_attachment_model.nil?
			return RicAssortment::ProductAttachment
		else
			return @@product_attachment_model.constantize
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

	#
	# Product photo model
	#
	mattr_accessor :product_photo_model
	def self.product_photo_model
		if @@product_photo_model.nil?
			return RicAssortment::ProductPhoto
		else
			return @@product_photo_model.constantize
		end
	end

end
