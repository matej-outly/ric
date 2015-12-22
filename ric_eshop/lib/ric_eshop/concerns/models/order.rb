# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Order
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicEshop
	module Concerns
		module Models
			module Order extend ActiveSupport::Concern

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
					# One-to-many relation with order items
					#
					has_many :order_items, class_name: RicEshop.order_item_model.to_s, dependent: :destroy
					
					# *********************************************************
					# Enums
					# *********************************************************

					#
					# Payment type
					#
					enum_column :payment_type, config(:payment_types)

					#
					# Payment state
					#
					enum_column :payment_state, [:paid, :in_progress, :not_paid]

					#
					# Delivery type
					#
					enum_column :delivery_type, config(:delivery_types)

					#
					# Currency
					#
					enum_column :currency, config(:currencies)

					# *********************************************************
					# Addresses
					# *********************************************************

					#
					# Billing address
					#
					address_column :billing_address

					# *********************************************************
					# Virtual attributes
					# *********************************************************

					#
					# Accept terms
					#
					attr_accessor :accept_terms

					# *********************************************************
					# Callbacks
					# *********************************************************

					before_create :synchronize_customer

					after_create :synchronize_items

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Payment and delivery type
					#
					validates_presence_of :payment_type, :delivery_type

					#
					# Apply custom validator
					#
					validate :validate_accept_terms

					# *********************************************************
					# JSON
					# *********************************************************

					#
					# Define additional methods to JSON export
					#
					add_methods_to_json [:price, :payment_state]

				end

				module ClassMethods
					
					# *********************************************************
					# Scopes
					# *********************************************************

				end

				# *************************************************************
				# Payment
				# *************************************************************

				#
				# Is order already paid?
				#
				def paid?
					return !self.paid_at.nil?
				end

				#
				# Is some payment in progress?
				#
				def payment_in_progress?
					return !self.payment_session_id.nil?
				end

				#
				# Is order locked for editing?
				#
				def locked?
					return payment_in_progress? || paid?
				end

				#
				# Payment state
				#
				def payment_state
					return "paid" if paid?
					return "in_progress" if payment_in_progress?
					return "not_paid"
				end

				#
				# Total price
				#
				def price
					result = 0
					self.order_items.each do |order_item|
						result += order_item.price
					end
					return result
				end

				# *************************************************************
				# Terms
				# *************************************************************

				#
				# Override accept terms validation
				#
				def override_accept_terms
					self.accept_terms = true
				end

				# *************************************************************
				# Cart
				# *************************************************************

				#
				# Get cart object
				#
				def cart
					if @cart.nil?
						@cart = RicEshop.cart_model.find(self.session_id)
					end
					return @cart
				end
				
			protected

				# *************************************************************
				# Callbacks
				# *************************************************************

				#
				# Copy relevant attributes from binded customer to order
				#
				def synchronize_customer
					if !self.customer_id.blank?
						self.product_name = self.customer.name
						self.product_email = self.customer.email
						self.product_phone = self.customer.phone
					end
				end

				#
				# Move items from cart to order
				#
				def synchronize_items
					if !self.session_id.blank?
						self.cart.cart_items.each do |cart_item|
							self.order_items.create(product_id: cart_item.product_id, sub_product_ids: cart_item.sub_product_ids, amount: cart_item.amount)
						end
						self.cart.virtual_items.each do |virtual_item|
							self.order_items.create(product_name: virtual_item.name, product_price: virtual_item.price, product_currency: virtual_item.currency, amount: 1)
						end
						self.cart.clear
					end
				end

				# *************************************************************
				# Validators
				# *************************************************************

				#
				# Validate if accept terms is set to true
				#
				def validate_accept_terms
					if self.accept_terms != true && self.accept_terms != "1"
						errors.add(:accept_terms, I18n.t("activerecord.errors.models.#{RicEshop.order_model.model_name.i18n_key}.attributes.accept_terms.not_true"))
					end
				end

			end
		end
	end
end