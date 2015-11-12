# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Order item
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	module Concerns
		module Models
			module OrderItem extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# One-to-many relation with order
					#
					belongs_to :order, class_name: RicEshop.order_model.to_s

					#
					# One-to-many relation with product
					#
					belongs_to :product, class_name: RicEshop.product_model.to_s

					# *********************************************************
					# Enums
					# *********************************************************

					#
					# Currency
					#
					enum_column :product_currency, config(:currencies)

					# *********************************************************************
					# Validators
					# *********************************************************************

					# *********************************************************************
					# Callbacks
					# *********************************************************************

					before_create :synchronize_product

					# *********************************************************
					# JSON
					# *********************************************************

					#
					# Define additional methods to JSON export
					#
					add_methods_to_json [:price]

				end

				module ClassMethods
					
					# *********************************************************************
					# Scopes
					# *********************************************************************

				end

				#
				# Item price
				#
				def price
					if !self.product_price.blank? && !self.amount.blank?
						return self.product_price * self.amount
					else
						return 0
					end
				end

			protected

				#
				# Copy relevant items from binded product to order item
				#
				def synchronize_product
					if !self.product_id.blank?
						self.product_name = self.product.name
						self.product_price = self.product.price
						self.product_currency = self.product.currency
					end
				end

			end
		end
	end
end