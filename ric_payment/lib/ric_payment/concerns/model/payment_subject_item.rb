# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment subject item (to be included to OrderItem model or matching structure)
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicPayment
	module Concerns
		module Models
			module PaymentSubjectItem extend ActiveSupport::Concern

				# *************************************************************
				# Attributes for gateway (to be overriden)
				# *************************************************************
				
				#
				# Item name for payment gateway
				#
				def payment_name
					return self.product_name
				end

				#
				# Item description for payment gateway
				#
				def payment_description
					return nil
				end

				#
				# Amount of money to pay for this item
				#
				def payment_price
					return self.price
				end

				#
				# Amount similar items in the order
				#
				def payment_amount
					return self.amount
				end

			end
		end
	end
end
