# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Cart
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	module Concerns
		module Models
			module Cart extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					

				end

				module ClassMethods
					
					#
					# Get cart object
					#
					def find(session_id)
						return RicEshop.cart_model.new(session_id)
					end

					#
					# Cleanup old cart items
					#
					def cleanup
						now = Time.current
						RicEshop.cart_item_model.delete_all(["updated_at < ?", (now - 1.day)])
					end

					# 
					# Define virtual item
					#
					def virtual_item(&block)
						@virtual_items_blocks = [] if @virtual_items_blocks.nil?
						@virtual_items_blocks << block
					end

					#
					# Get virtual item definitions
					#
					def virtual_items_blocks
						@virtual_items_blocks
					end

				end

				#
				# Constructor
				#
				def initialize(session_id)
					@session_id = session_id
				end

				#
				# Get session id
				#
				def session_id
					return @session_id
				end

				#
				# Delete object cache
				#
				def delete_cache
					@cart_items = nil
					@virtual_items = nil
					@products = nil
				end

				#
				# Add new product (if not already added)
				#
				def add(product_id, sub_product_ids = nil)
					if !product_id.nil?

						# Prepare subproducts
						if !sub_product_ids.nil?
							sub_product_ids = sub_product_ids.sort
							if sub_product_ids.empty?
								sub_product_ids = nil
							end
						end
						if sub_product_ids.nil?
							sub_product_ids_as_json = nil
						else
							sub_product_ids_as_json = sub_product_ids.to_json
						end

						# Try to find cart item with given product and sub products
						cart_item = RicEshop.cart_item_model.where(session_id: @session_id, product_id: product_id, sub_product_ids: sub_product_ids_as_json).first
						
						if cart_item.nil?
							return false if !check_valid_product(product_id)
							if sub_product_ids
								sub_product_ids.each do |sub_product_id|
									return false if !check_valid_product(sub_product_id)
								end
							end
							delete_cache
							cart_item = RicEshop.cart_item_model.new(session_id: @session_id, product_id: product_id, sub_product_ids: sub_product_ids_as_json, amount: 1)
							return cart_item.save
						else
							delete_cache
							cart_item.amount += 1
							return cart_item.save
						end
					else
						return false
					end
				end

				#
				# Remove product (if added)
				#
				def remove(product_id, sub_product_ids = nil)
					if !product_id.nil?

						# Prepare subproducts
						if !sub_product_ids.nil?
							sub_product_ids = sub_product_ids.sort
							if sub_product_ids.empty?
								sub_product_ids = nil
							end
						end
						if sub_product_ids.nil?
							sub_product_ids_as_json = nil
						else
							sub_product_ids_as_json = sub_product_ids.to_json
						end

						# Try to find cart item with given product and sub products
						cart_item = RicEshop.cart_item_model.where(session_id: @session_id, product_id: product_id, sub_product_ids: sub_product_ids_as_json).first
						
						if !cart_item.nil?
							if cart_item.amount > 1
								delete_cache
								cart_item.amount -= 1
								return cart_item.save
							else
								delete_cache
								return cart_item.destroy
							end
						else
							return true
						end
					else
						return false
					end
				end

				#
				# Remove all products
				#
				def clear
					delete_cache
					RicEshop.cart_item_model.delete_all(session_id: @session_id)
					return true
				end

				#
				# All binded products
				#
				def cart_items
					if @cart_items.nil?
						@cart_items = RicEshop.cart_item_model.where(session_id: @session_id).order(created_at: :asc)
					end
					return @cart_items
				end

				#
				# All virtual products
				#
				def virtual_items
					if @virtual_items.nil?
						@virtual_items = []
						self.class.virtual_items_blocks.each do |virtual_item_block|
							virtual_item = virtual_item_block.call(self)
							@virtual_items << virtual_item if virtual_item
						end
					end
					return @virtual_items
				end

				#
				# Total price
				#
				def price
					if @price.nil?
						@price = 0
						self.cart_items.each do |cart_item|
							@price += cart_item.price
						end
						self.virtual_items.each do |virtual_item|
							@price += virtual_item.price
						end
					end
					return @price
				end

				#
				# Total amount of items in the cart
				#
				def amount
					if @amount.nil?
						@amount = 0
						self.cart_items.each do |cart_item|
							@amount += cart_item.amount
						end
					end
					return @amount
				end

				#
				# Is cart empty?
				#
				def empty?
					return (cart_items.count == 0)
				end

				#
				# Convert cart object to JSON
				#
				def to_json(options = nil)

					# Call parent method
					hash = as_json(options)
					hash.delete("cart_items")
					hash.delete("price")
					hash.delete("amount")

					result = '{'
					
					# Common attributes
					result << hash.map do |key, value|
						"#{ActiveSupport::JSON.encode(key.to_s)}:#{ActiveSupport::JSON.encode(value)}"
					end * ','

					result << ","

					# Cart items
					encoded_cart_items = "["
					encoded_cart_items << self.cart_items.map do |cart_item|
						cart_item.to_json
					end * ','
					encoded_cart_items << "]"
					result << "#{ActiveSupport::JSON.encode("cart_items")}:#{encoded_cart_items},"
					
					# Price
					result << "#{ActiveSupport::JSON.encode("price")}:#{ActiveSupport::JSON.encode(self.price)},"
					
					# Amount
					result << "#{ActiveSupport::JSON.encode("amount")}:#{ActiveSupport::JSON.encode(self.amount)}"

					result << '}'

					return result
				end

			protected

				def check_valid_product(product_id)
					product = RicEshop.product_model.find_by_id(product_id)
					return !product.nil?
				end

			end
		end
	end
end