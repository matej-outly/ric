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
					
					#
					# Tableless
					#
					has_no_table

					#
					# Validate if added products exists
					#
					validate :validate_added_items

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
						RicEshop.cart_item_model.delete_all(["updated_at < ?", (now - self.cleanup_timeout)])
					end

					#
					# Get cleanup timeout
					#
					def cleanup_timeout
						return 1.day
					end

					# *********************************************************
					# Virtual items
					# *********************************************************

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
				# Get session ID
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
					@cart_items_to_add = nil
					@cart_items_to_remove = nil
					@price = nil
					@amount = nil
				end

				# *************************************************************
				# Cart items
				# *************************************************************

				#
				# All binded items
				#
				def cart_items
					if @cart_items.nil?
						@cart_items = RicEshop.cart_item_model.where(session_id: @session_id).order(created_at: :asc)
					end
					return @cart_items
				end

				#
				# Add new cart item (if not already added)
				#
				def add(params = {})
					@cart_items_to_add = [] if @cart_items_to_add.nil?
					@cart_items_to_add << params
				end

				#
				# Remove cart item (if added)
				#
				def remove(params = {})
					@cart_items_to_remove = [] if @cart_items_to_remove.nil?
					@cart_items_to_remove << params
				end

				#
				# Validate and save all added items to DB
				#
				def save

					# Validation
					if !self.validate
						return false
					end

					# Add
					if @cart_items_to_add
						@cart_items_to_add.each do |params|
							cart_item_params = cart_item_params(params)
							cart_item = RicEshop.cart_item_model.where(session_id: @session_id).where(cart_item_params).first
							if cart_item.nil?
								cart_item = RicEshop.cart_item_model.create(cart_item_params.merge({session_id: @session_id, amount: 1}))
							else
								cart_item.amount += 1
								cart_item.save
							end
						end
					end

					# Remove
					if @cart_items_to_remove
						@cart_items_to_remove.each do |params|
							cart_item_params = cart_item_params(params)
							cart_item = RicEshop.cart_item_model.where(session_id: @session_id).where(cart_item_params).first
							if !cart_item.nil?
								if cart_item.amount > 1
									cart_item.amount -= 1
									cart_item.save
								else
									cart_item.destroy
								end
							end
						end
					end

					# Delete cache
					self.delete_cache

					return true
				end

				#
				# Remove all products
				#
				def clear
					
					# Delete all
					RicEshop.cart_item_model.delete_all(session_id: @session_id)
					
					# Delete cache
					self.delete_cache

					return true
				end

				#
				# Is cart empty?
				#
				def empty?
					return (self.cart_items.count == 0)
				end

				# *************************************************************
				# Virtual items
				# *************************************************************

				#
				# All virtual items
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

				# *************************************************************
				# Total price
				# *************************************************************
				
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

				# *************************************************************
				# Total amount of items in the cart
				# *************************************************************

				def amount
					if @amount.nil?
						@amount = 0
						self.cart_items.each do |cart_item|
							@amount += cart_item.amount
						end
					end
					return @amount
				end

				# *************************************************************
				# JSON
				# *************************************************************

				#
				# Convert cart object to JSON
				#
				def to_json(options = nil)

					result = '{'
					
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

				def validate_added_items
					if @cart_items_to_add
						@cart_items_to_add.each do |params|
							if params[:product_id]
								if !validate_product(params[:product_id])
									errors.add(:cart_items, I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.attributes.cart_items.invalid_product"))
								end
							end
							if params[:sub_product_ids]
								params[:sub_product_ids].each do |sub_product_id|
									if !validate_product(sub_product_id)
										errors.add(:cart_items, I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.attributes.cart_items.invalid_sub_product"))
									end
								end
							end
						end
					end
				end

				def validate_product(product_id)
					product = RicEshop.product_model.find_by_id(product_id)
					return !product.nil?
				end

				#
				# Get all permitted params
				#
				def cart_item_permitted_params
					[:product_id, :sub_product_ids]
				end

				# 
				# Compose params object
				#
				def cart_item_params(params)

					result = {}
					
					# Filter allowed params (and fill up nil if not defined)
					self.cart_item_permitted_params.each do |permitted_param|
						result[permitted_param] = params[permitted_param]
					end 

					# Subproducts
					sub_product_ids = params[:sub_product_ids]
					if sub_product_ids
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
					result[:sub_product_ids] = sub_product_ids_as_json

					return result
				end

			end
		end
	end
end