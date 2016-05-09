# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer data - cart
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		module CustomerData
			class Cart

				#
				# Cart items.
				#
				attr_accessor :items
				
				#
				# Price without tax, discount and shipping.
				#
				attr_accessor :subtotal_without_decimal
				def subtotal
					return (self.subtotal_without_decimal / 100).to_f
				end

				#
				# Price with tax, discount and shipping.
				#
				def total_without_decimal
					return (self.subtotal_without_decimal + self.tax_without_decimal + self.discount_without_decimal + self.shipping_without_decimal)
				end
				def total
					return (self.total_without_decimal / 100).to_f
				end

				#
				# Dsicount.
				#
				attr_accessor :discount_without_decimal
				def discount=(discount)
					self.discount_without_decimal = self.number_without_decimal(discount)
					if self.discount_without_decimal > 0
						self.discount_without_decimal = self.discount_without_decimal * -1;
					end
				end
				def discount
					return (self.discount_without_decimal / 100).to_f
				end

				#
				# Tax.
				#
				attr_accessor :tax_without_decimal
				def tax=(tax)
					self.tax_without_decimal = self.number_without_decimal(tax)
				end
				def tax
					return (self.tax_without_decimal / 100).to_f
				end

				#
				# Shipping fee.
				#
				attr_accessor :shipping_without_decimal
				def shipping=(shipping)
					self.shipping_without_decimal = self.number_without_decimal(shipping)
				end
				def shipping
					return (self.shipping_without_decimal / 100).to_f
				end

				#
				# Currency.
				#
				attr_accessor :currency

				#
				# Add item to cart
				#
				def add(cart_item)
					self.subtotal_without_decimal += (cart_item.price_without_decimal * cart_item.quantity);
					self.items << cart_item
				end

				#
				# Export model to JSON
				#
				def as_json(options = {})
					items = []
					self.items.each do |item| 
						items << item.as_json
					end
					result = {
						"subtotal" => self.subtotal_without_decimal,
						"total" => self.total_without_decimal,
						"shipping" => self.shipping_without_decimal,
						"tax" => self.tax_without_decimal,
						"discount" => self.discount_without_decimal,
						"items" => items
					}
					return result
				end

				#
				# Constructor
				#
				def initialize(data = {})
					self.items = []
					self.subtotal_without_decimal = 0
					self.discount_without_decimal = 0
					self.tax_without_decimal = 0
					self.shipping_without_decimal = 0
					self.currency = Config.default_currency
					
					self.discount = data[:discount] if !data[:discount].nil?
					self.tax = data[:tax] if !data[:tax].nil?
					self.shipping = data[:shipping] if !data[:shipping].nil?
					self.currency = data[:currency] if !data[:currency].nil?
				end

			protected

				def number_without_decimal(number)
					number = number.to_f.round(2)
					return (number * 100).to_i
				end

			end
		end
	end
end