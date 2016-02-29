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
require 'ric_assortment/concerns/models/product_variant'

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
	# Enable photos subsystem
	#
	mattr_accessor :enable_photos
	@@enable_photos = false

	#
	# Product photo model
	#
	mattr_accessor :product_photo_model
	def self.product_photo_model
		return @@product_photo_model.constantize
	end
	@@product_photo_model = "RicAssortment::ProductPhoto"

	#
	# Enable attachments subsystem
	#
	mattr_accessor :enable_attachments
	@@enable_attachments = false

	#
	# Product attachment model
	#
	mattr_accessor :product_attachment_model
	def self.product_attachment_model
		return @@product_attachment_model.constantize
	end
	@@product_attachment_model = "RicAssortment::ProductAttachment"

	#
	# Enable categories subsystem
	#
	mattr_accessor :enable_categories
	@@enable_categories = false

	#
	# Product category model
	#
	mattr_accessor :product_category_model
	def self.product_category_model
		return @@product_category_model.constantize
	end
	@@product_category_model = "RicAssortment::ProductCategory"

	#
	# Enable tickers subsystem
	#
	mattr_accessor :enable_tickers
	@@enable_tickers = false

	#
	# Product ticker model
	#
	mattr_accessor :product_ticker_model
	def self.product_ticker_model
		return @@product_ticker_model.constantize
	end
	@@product_ticker_model = "RicAssortment::ProductTicker"

	#
	# Enable variants subsystem
	#
	mattr_accessor :enable_variants
	@@enable_variants = false

	#
	# Product variant model
	#
	mattr_accessor :product_variant_model
	def self.product_variant_model
		return @@product_variant_model.constantize
	end
	@@product_variant_model = "RicAssortment::ProductVariant"



end
