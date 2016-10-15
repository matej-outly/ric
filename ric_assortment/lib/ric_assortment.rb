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
require "ric_assortment/concerns/models/product"
require "ric_assortment/concerns/models/product_attachment"
require "ric_assortment/concerns/models/product_category"
require "ric_assortment/concerns/models/product_picture"
require "ric_assortment/concerns/models/product_teaser"

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
	# Product category model
	#
	mattr_accessor :product_category_model
	def self.product_category_model
		return @@product_category_model.constantize
	end
	@@product_category_model = "RicAssortment::ProductCategory"

	#
	# Enable pictures subsystem
	#
	mattr_accessor :enable_pictures
	@@enable_pictures = true

	#
	# Product picture model
	#
	mattr_accessor :product_picture_model
	def self.product_picture_model
		return @@product_picture_model.constantize
	end
	@@product_picture_model = "RicAssortment::ProductPicture"

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
	# Enable teasers subsystem
	#
	mattr_accessor :enable_teasers
	@@enable_teasers = false

	#
	# Product teaser model
	#
	mattr_accessor :product_teaser_model
	def self.product_teaser_model
		return @@product_teaser_model.constantize
	end
	@@product_teaser_model = "RicAssortment::ProductTeaser"

end
