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

	#
	# Order item model
	#
	mattr_accessor :order_item_model
	def self.order_item_model
		if @@order_item_model.nil?
			return RicEshop::OrderItem
		else
			return @@order_item_model.constantize
		end
	end

	#
	# Cart model
	#
	mattr_accessor :cart_model
	def self.cart_model
		if @@cart_model.nil?
			return RicEshop::Cart
		else
			return @@cart_model.constantize
		end
	end

	#
	# Cart item model
	#
	mattr_accessor :cart_item_model
	def self.cart_item_model
		if @@cart_item_model.nil?
			return RicEshop::CartItem
		else
			return @@cart_item_model.constantize
		end
	end

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

end
