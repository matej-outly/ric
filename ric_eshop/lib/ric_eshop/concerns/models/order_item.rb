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
					
					# *********************************************************
					# Structure
					# *********************************************************

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

					# *********************************************************
					# Validators
					# *********************************************************

					# *********************************************************
					# Callbacks
					# *********************************************************

					before_create :synchronize_products

					# *********************************************************
					# JSON
					# *********************************************************

					#
					# Define additional methods to JSON export
					#
					add_methods_to_json [:price]

					# *********************************************************
					# Sub products
					# *********************************************************

					array_column :sub_product_ids
					array_column :sub_product_names
					array_column :sub_product_prices
					array_column :sub_product_currencies

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
						result = self.product_price
						if !self.sub_product_prices.blank?
							self.sub_product_prices.each do |sub_product_price|
								result += sub_product_price
							end
						end
						return result * self.amount
					else
						return 0
					end
				end

			protected

				#
				# Copy relevant items from binded product to order item
				#
				def synchronize_products
					if !self.product_id.blank?
						self.product_name = self.product.name
						self.product_price = self.product.price
						self.product_currency = self.product.currency
					#else
					#	self.product_name = nil
					#	self.product_price = nil
					#	self.product_currency = nil
					end
					if !self.sub_product_ids.blank?
						names = []
						prices = []
						currencies = []
						self.sub_product_ids.each do |sub_product_id|
							sub_product = RicEshop.product_model.find_by_id(sub_product_id)
							if sub_product
								names << sub_product.name
								prices << sub_product.price
								currencies << sub_product.currency
							end
						end
						self.sub_product_names = names
						self.sub_product_prices = prices
						self.sub_product_currencies = currencies
					#else
					#	self.sub_product_names = nil
					#	self.sub_product_prices = nil
					#	self.sub_product_currencies = nil
					end
				end

			end
		end
	end
end