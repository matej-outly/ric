# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer data - cart item
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		module ShoppingCart
			class CartItem

				#
				# Item name.
				#
				attr_accessor :name

				#
				# Item description.
				#
				attr_accessor :description

				#
				# Quantity.
				#
				attr_accessor :quantity
				
				#
				# Price.
				#
				attr_accessor :price_without_decimal
				def price=(price)
					price = price.to_f.round(2)
					self.price_without_decimal = (price * 100).to_i
				end
				def price
					return (self.price_without_decimal / 100).to_f
				end

				#
				# Export model to JSON
				#
				def as_json(options = {})
					result = {
						"name" => self.name.to_s,
						"description" => self.description.to_s,
						"quantity" => self.quantity.to_i,
						"price" => self.price_without_decimal
					}
					return result
				end

				#
				# Constructor
				#
				def initialize(data = {})
					self.price_without_decimal = 0
					self.quantity = 1
					
					self.name = data[:name] if !data[:name].nil?
					self.description = data[:description] if !data[:description].nil?
					self.quantity = data[:quantity] if !data[:quantity].nil?
					self.price = data[:price] if !data[:price].nil?
				end

			end
		end
	end
end