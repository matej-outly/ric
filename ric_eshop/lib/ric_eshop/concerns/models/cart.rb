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
					@products = nil
				end

				#
				# Add new product (if not already added)
				#
				def add(product_id)
					if !product_id.nil?
						cart_item = RicEshop.cart_item_model.where(session_id: @session_id, product_id: product_id).first
						if cart_item.nil?
							product = RicEshop.product_model.find_by_id(product_id)
							if product
								delete_cache
								cart_item = RicEshop.cart_item_model.new(session_id: @session_id, product_id: product_id, amount: 1)
								return cart_item.save
							else
								return false
							end
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
				def remove(product_id)
					if !product_id.nil?
						cart_item = RicEshop.cart_item_model.where(session_id: @session_id, product_id: product_id).first
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
						@cart_items = RicEshop.cart_item_model.where(session_id: @session_id)
					end
					return @cart_items
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

			end
		end
	end
end