# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer data - order
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		module CustomerData
			class Order

				#
				# Cart object.
				#
				attr_accessor :cart

				#
				# Customer object.
				#
				attr_accessor :customer

				#
				# Export model to JSON
				#
				def as_json(options = {})
					result = {}
					result["first_name"] = self.customer.first_name.to_s
					result["last_name"] = self.customer.last_name.to_s
					result["currency"] = self.cart.currency.to_s
					result["amount"] = self.cart.total_without_decimal
					result["mobile_phone"] = self.customer.mobile_phone if !self.customer.mobile_phone.blank?
					result["city"] = self.customer.city.to_s
					result["postal_code"] = self.customer.postal_code.to_s
					result["address"] = self.customer.address.to_s
					result["email"] = self.customer.email.to_s
					result["shopping_cart"] = self.cart.as_json

					return result
				end

				#
				# Initialize
				#
				def initialize(customer, cart)
					self.customer = customer
					self.cart = cart
				end

			end
		end
	end
end