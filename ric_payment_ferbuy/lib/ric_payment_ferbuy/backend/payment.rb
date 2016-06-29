# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment object
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

# Shopping cart
require "ric_payment_ferbuy/backend/shopping_cart/cart"
require "ric_payment_ferbuy/backend/shopping_cart/cart_item"

module RicPaymentFerbuy
	class Backend
		class Payment
			
			# *****************************************************************
			# Status values
			# *****************************************************************

			#
			# Transaction successful
			#
			STATUS_SUCCESSFUL = 200
			
			#
			# Transaction successful – Awaiting shipment by merchant
			#
			STATUS_SUCCESSFUL_AWAITING = 250
			
			#
			# Refund
			#
			STATUS_REFUND = 300
			
			#
			# Transaction failed
			#
			STATUS_FAILED = 400
			
			#
			# Transaction timed out
			#
			STATUS_TIMED_OUT = 408
			
			#
			# Transaction cancelled by consumer
			#
			STATUS_CANCELED_CONSUMER = 410
			
			#
			# Transaction cancelled by merchant
			#
			STATUS_CANCELED_MERCHANT = 411
			
			#
			# Application error
			#
			STATUS_ERROR = 500
			
			#
			# Transaction order fulfilled - ???
			#
			STATUS_ORDER_FULFILLED = 600
			
			#
			# Awaiting manual approval - ??? 
			#
			STATUS_AWAITING_APPROVAL = 800
			
			# *****************************************************************
			# Common attributes
			# *****************************************************************

			#
			# Value indicating the amount of money that should be paid
			#
			attr_accessor :value
			def value=(value)
				value = value.to_f
				if value < 0.0
					raise "Payment value can't be below zero."
				end
				@value = value
			end
			def value
				return sprintf('%.2f', @value.to_f)
			end

			#
			# Amount of money in cents
			#
			def amount=(amount)
				self.value = amount.to_f / 100
			end
			def amount
				return (self.value * 100).to_i
			end

			#
			# Currency identifier (ISO-4217)
			#
			attr_accessor :currency

			#
			# Identification of the payment at the e-shop (order ID)
			#
			attr_accessor :reference

			#
			# Order number (ID)
			#
			def order_number=(order_number)
				self.reference = "order-#{order_number}"
			end
			def order_number
				if self.reference.nil?
					return nil
				else
					splitted_reference = self.reference.split("-")
					if splitted_reference.length == 2
						return splitted_reference[1].to_i
					else
						return nil
					end
				end
			end

			# *****************************************************************
			# Query specific attributes
			# *****************************************************************

			#
			# URL where to redirect the user after the payment has been 
			# successfully completed.
			#
			attr_accessor :return_url_ok

			#
			# URL where to redirect the user after the payment failed or has 
			# been canceled.
			#
			attr_accessor :return_url_cancel

			#
			# Optional data about shopping cart.
			#
			attr_accessor :shopping_cart

			#
			# Customer’s first name.
			#
			attr_accessor :first_name

			#
			# Customer’s last name.
			#
			attr_accessor :last_name

			#
			# Customer’s address (street + number).
			#
			attr_accessor :address

			#
			# Customer’s address postal code.
			#
			attr_accessor :postal_code

			#
			# Customer’s address city.
			#
			attr_accessor :city

			#
			# Customer’s country (ISO-3166).
			#
			attr_accessor :country_iso

			#
			# Customer’s mobile phone number.
			#
			attr_accessor :mobile_phone

			#
			# Customer’s e-mail address.
			#
			attr_accessor :email

			#
			# Customer’s interface language code (i.e. cs or cs_CZ).
			#
			attr_accessor :language

			# *****************************************************************
			# Notification specific attributes
			# *****************************************************************

			#
			# Payment environment (demo or live).
			#
			attr_accessor :env

			#
			# Unique payment ID in the FerBuy system.
			#
			attr_accessor :transaction_id
			def transaction_id=(transaction_id)
				@transaction_id = transaction_id.to_s
			end

			#
			# Unique payment ID in the FerBuy system.
			#
			def id
				return self.transaction_id
			end

			#
			# Payment status. One of enum values specified in the FerBuy 
			# documentation.
			#
			attr_accessor :status
			def status=(status)
				@status = status.to_i
			end

			# *****************************************************************
			# Query
			# *****************************************************************

			QUERY_ARGS = {
				"reference" => "reference", 
				"currency" => "currency", 
				"amount" => "amount", 
				"return_url_ok" => "return_url_ok",
				"return_url_cancel" => "return_url_cancel",
				"first_name" => "first_name",
				"last_name" => "last_name",
				"address" => "address",
				"postal_code" => "postal_code",
				"city" => "city",
				"country_iso" => "country_iso",
				"mobile_phone" => "mobile_phone",
				"email" => "email",
				"shopping_cart" => "shopping_cart",
				"language" => "language",
			}

			#
			# List arguments to put into the POST request. Returns associative
			# array of arguments that should be contained in the FerBuy gate call.
			#
			def query_data
				result = {}

				result["site_id"] = Config.site_id
				QUERY_ARGS.each do |param_name, attribute_name|
					value = self.send(attribute_name)
					if !value.nil?
						if value.is_a?(ShoppingCart::Cart)
							result[param_name] = value.to_json
						else
							result[param_name] = value 
						end
					end
				end
				result["checksum"] = Checksum.query(result)
				
				return result
			end

			# *****************************************************************
			# Notification
			# *****************************************************************

			NOTIFICATION_REQUIRED_ARGS = {
				"env" => "env", 
				"reference" => "reference", 
				"transaction_id" => "transaction_id", 
				"status" => "status", 
				"currency" => "currency",
				"amount" => "amount", 
			}

			NOTIFICATION_OPTIONAL_ARGS = {
			}

			def load_from_params(params)
				
				# Special params
				@notification_site_id = params["site_id"].to_i if !params["site_id"].blank?
				@notification_checksum = params["checksum"]

				# Required params
				NOTIFICATION_REQUIRED_ARGS.each do |param_name, attribute_name|
					if params[param_name]
						self.send("#{attribute_name}=", params[param_name])
					else
						return false
					end
				end

				# Optional params
				NOTIFICATION_OPTIONAL_ARGS.each do |param_name, attribute_name|
					if params[param_name]
						self.send("#{attribute_name}=", params[param_name])
					end
				end
				
				return true
			end

			#
			# Verify if checksum loaded from params is correct
			#
			def verify_notification_checksum
				if @notification_site_id != Config.site_id
					return false
				end
				
				# Compute signature from current data
				data = {}
				data["site_id"] = @notification_site_id.to_s
				NOTIFICATION_REQUIRED_ARGS.merge(NOTIFICATION_OPTIONAL_ARGS).each do |param_name, attribute_name|
					value = self.send(attribute_name)
					data[param_name] = value if !value.nil?
				end
				data_checksum = Checksum.notification(data)
				
				if data_checksum == @notification_checksum
					return true
				else
					return false
				end
			end

			# *****************************************************************
			# Payment subject
			# *****************************************************************

			def load_from_subject(payment_subject)

				self.value = payment_subject.payment_price
				self.currency = Payment.locale_to_currency(payment_subject.payment_currency)
				self.order_number = payment_subject.id
				
				self.first_name = payment_subject.payment_customer_firstname
				self.last_name = payment_subject.payment_customer_lastname
				if !payment_subject.payment_customer_address.nil?
					self.address = payment_subject.payment_customer_address[:street] + " " + payment_subject.payment_customer_address[:number]
					self.postal_code = payment_subject.payment_customer_address[:zipcode]
					self.city = payment_subject.payment_customer_address[:city]
					self.country_iso = "CZ" # TODO
				end
				self.mobile_phone = payment_subject.payment_customer_phone
				self.email = payment_subject.payment_customer_email
				self.language = "cs_CZ" # TODO
				
				# Shopping cart
				cart_object = ShoppingCart::Cart.new({
					shipping: payment_subject.payment_price_shipping,
					tax: payment_subject.payment_price_tax,
					discount: payment_subject.payment_price_discount,
				})
				payment_subject.payment_items.each do |payment_subject_item|
					cart_object.add(
						ShoppingCart::CartItem.new({
							name: payment_subject_item.payment_name,
							description: payment_subject_item.payment_description,
							price: payment_subject_item.payment_price,
							quantity: payment_subject_item.payment_amount,
						})
					)
				end
				self.shopping_cart = cart_object

				return true
			end

		protected

			#
			# Translate locale to currency identifier used in FerBuy system
			#
			def self.locale_to_currency(locale)
				locale_to_currency = {
					"cs" => "CZK",
					"sk" => "EUR"
				}
				return locale_to_currency[locale.to_s] if locale_to_currency[locale.to_s]
				return Config.default_currency
			end
		
		end
	end
end