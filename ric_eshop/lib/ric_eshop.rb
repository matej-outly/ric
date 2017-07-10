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

# Engines
require "ric_eshop/admin_engine"
require "ric_eshop/public_engine"

# Models
require 'ric_eshop/concerns/models/order'
require 'ric_eshop/concerns/models/order_item'
require 'ric_eshop/concerns/models/cart'
require 'ric_eshop/concerns/models/cart_item'

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
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Resource model
	#
	mattr_accessor :order_model
	def self.order_model
		return @@order_model.constantize
	end
	@@order_model = "RicEshop::Order"

	#
	# Order item model
	#
	mattr_accessor :order_item_model
	def self.order_item_model
		return @@order_item_model.constantize
	end
	@@order_item_model = "RicEshop::OrderItem"

	#
	# Cart model
	#
	mattr_accessor :cart_model
	def self.cart_model
		return @@cart_model.constantize
	end
	@@cart_model = "RicEshop::Cart"

	#
	# Cart item model
	#
	mattr_accessor :cart_item_model
	def self.cart_item_model
		return @@cart_item_model.constantize
	end
	@@cart_item_model = "RicEshop::CartItem"

	#
	# Session model
	#
	mattr_accessor :session_model
	def self.session_model
		return @@session_model.constantize
	end
	@@session_model = "RicUser::Session"

	#
	# Product model
	#
	mattr_accessor :product_model
	def self.product_model
		return @@product_model.constantize
	end
	@@product_model = "RicAssortment::Product"

	#
	# Class or object implementing actions_options, tabs_options, etc. can be set.
	#
	mattr_accessor :theme
	def self.theme
		if @@theme
			return @@theme.constantize if @@theme.is_a?(String)
			return @@theme
		end
		return OpenStruct.new
	end
	@@theme = nil
	
end
