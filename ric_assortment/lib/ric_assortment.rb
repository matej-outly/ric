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
require 'ric_assortment/concerns/models/product_ticker'
require 'ric_assortment/concerns/models/product_panel'

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
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Product model
	#
	mattr_accessor :product_model
	def self.product_model
		return @@product_model.constantize
	end
	@@product_model = "RicAssortment::Product"

	#
	# Product attachment model
	#
	mattr_accessor :product_attachment_model
	def self.product_attachment_model
		return @@product_attachment_model.constantize
	end
	@@product_attachment_model = "RicAssortment::ProductAttachment"

	#
	# Product category model
	#
	mattr_accessor :product_category_model
	def self.product_category_model
		return @@product_category_model.constantize
	end
	@@product_category_model = "RicAssortment::ProductCategory"

	#
	# Product photo model
	#
	mattr_accessor :product_photo_model
	def self.product_photo_model
		return @@product_photo_model.constantize
	end
	@@product_photo_model = "RicAssortment::ProductPhoto"

	#
	# Product ticker model
	#
	mattr_accessor :product_ticker_model
	def self.product_ticker_model
		return @@product_ticker_model.constantize
	end
	@@product_ticker_model = "RicAssortment::ProductTicker"

	#
	# Product panel model
	#
	mattr_accessor :product_panel_model
	def self.product_panel_model
		return @@product_panel_model.constantize
	end
	@@product_panel_model = "RicAssortment::ProductPanel"

end
