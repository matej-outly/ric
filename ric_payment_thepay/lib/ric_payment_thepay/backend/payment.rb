# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment object
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class Payment
			
			#
			# Value indicating the amount of money that should be paid
			#
			attr_accessor :value
			def value=(value)
				value = value.to_i
				if value < 0
					raise "Payment value can't be below zero."
				end
				@value = value
			end

			#
			# Currency identifier
			#
			attr_accessor :currency

			#
			# Payment description that should be visible to the customer
			#
			attr_accessor :description

			#
			# Any merchant-specific data, that will be returned to the site 
			# after the payment has been completed
			#
			attr_accessor :merchant_data

			#
			# Customer’s e-mail address. Used to send payment info and payment 
			# link from the payment info page
			#
			attr_accessor :customer_email

			#
			# URL where to redirect the user after the payment has been 
			# completed. It defaults to value configured in administration 
			# interface, but can be overwritten using this property.
			#
			attr_accessor :return_url

			#
			# ID of payment method to use for paying. Setting this argument 
			# hould be result of user's selection, not merchant's selection
			#
			attr_accessor :method_id

			#
			# If card payment will be charged immediately or only blocked and 
			# charged later by paymentDeposit operation
			#
			attr_accessor :is_deposit

			#
			# If card payment is recurring
			#
			attr_accessor :is_recurring

			#
			# Numerical specific symbol (used only if payment method supports it).
			#
			attr_accessor :merchant_specific_symbol

			#
			# List arguments to put into the URL. Returns associative array of
			# arguments that should be contained in the ThePay gate call.
			#
			def get_args
				result = {}

				result["merchantId"] = Config.merchant_id
				result["accountId"] = Config.account_id

				if !self.value.nil?
					result["value"] = self.value
				end

				if !self.currency.nil?
					result["currency"] = self.currency
				end

				if !self.description.nil?
					result["description"] = self.description
				end

				if !self.merchant_data.nil?
					result["merchantData"] = self.merchant_data
				end

				# Customer data (only for FerBuy order) TODO
				
				if !self.customer_email.nil?
					result["customerEmail"] = self.customer_email
				end

				if !self.return_url.nil?
					result["returnUrl"] = self.return_url
				end

				if !self.method_id.nil?
					result["methodId"] = self.method_id
				end

				if !self.is_deposit.nil?
					result["deposit"] = self.is_deposit
				end

				if !self.is_recurring.nil?
					result["isRecurring"] = self.is_recurring
				end

				if !self.merchant_specific_symbol.nil?
					result["merchantSpecificSymbol"] = self.merchant_specific_symbol
				end

				return result;
			end

			#
			# Returns signature to authenticate the payment. The signature
			# consists of hash of all specified parameters and the merchant
			# password specified in the configuration. So no one can alter the
			# payment, because the password is not known.
			#
			def get_signature
				result = ""
				get_args.each do |key, value|
					result += key + "=" + value.to_s + "&"
				end
				result += "password=" + Config.password
				return hash_function(result)
			end

			#
			# Build the query part of the URL from payment data and optional
			# helper data.
			#
			def get_query(optional_args = {})
				result = []
				all_args = get_args.merge(optional_args).merge({"signature" => get_signature})
				all_args.each do |key, value|
					result << (CGI.escape(key.to_s).gsub("+", "%20") + "=" + CGI.escape(value.to_s).gsub("+", "%20"))
				end
				return result.join("&amp;")
			end

			#
			# Function that calculates hash
			#
			def hash_function(str)
				return Digest::MD5.hexdigest(str)
			end

		end
	end
end