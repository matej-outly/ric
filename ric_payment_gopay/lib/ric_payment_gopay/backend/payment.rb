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

module RicPaymentGopay
	class Backend
		class Payment
			
			# *****************************************************************
			# Status values
			# *****************************************************************

			#
			# Correctly paid
			#
			STATUS_PAID = PaymentStatus::STATE_PAID

			#
			# Payment in progress, offline payment method chosen
			#
			STATUS_PAYMENT_METHOD_CHOSEN = PaymentStatus::STATE_PAYMENT_METHOD_CHOSEN

			#
			# Canceled by customer
			#
			STATUS_CANCELED = PaymentStatus::STATE_CANCELED
			
			#
			# Not paid in timeout
			#
			STATUS_TIMEOUT = PaymentStatus::STATE_TIMEOUTED
			
			#
			# Money refunded to customer
			#
			STATUS_REFUNDED = PaymentStatus::STATE_REFUNDED

			#
			# Money partially refunded to customer
			#
			STATUS_PARTIALLY_REFUNDED = PaymentStatus::STATE_PARTIALLY_REFUNDED

			# *****************************************************************
			# Attributes
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
			# Currency identifier
			#
			attr_accessor :currency

			#
			# Unique payment ID in the GoPay system
			#
			attr_accessor :payment_id
			def payment_id=(payment_id)
				@payment_id = payment_id.to_i
			end

			#
			# Unique payment ID in the GoPay system
			#
			def id
				return self.payment_id
			end

			#
			# Payment channel
			#
			attr_accessor :channel

			#
			# Order number
			#
			attr_accessor :order_number

			#
			# Payment description that should be visible to the customer
			#
			attr_accessor :description

			#
			# Customer data (email, first name, last name)
			#
			attr_accessor :customer

			#
			# Go ID returned from gateway
			#
			attr_accessor :target_go_id

			#
			# Encrypted signature returned from gateway
			#
			attr_accessor :encrypted_signature

			# *****************************************************************
			# Params returned from gateway
			# *****************************************************************

			RETURNED_ARGS = {
				"paymentSessionId" => "payment_id", 
				"orderNumber" => "order_number", 
				"targetGoId" => "target_go_id", 
				"encryptedSignature" => "encrypted_signature", 
			}

			def load_from_params(params)
				RETURNED_ARGS.each do |param_name, attribute_name|
					if params[param_name]
						self.send("#{attribute_name}=", params[param_name])
					end
				end
				return self
			end

			# *****************************************************************
			# Payment subject
			# *****************************************************************

			def load_from_subject(payment_subject)
				self.value = payment_subject.payment_price
				self.currency = Payment.locale_to_currency(payment_subject.payment_currency)
				self.description = payment_subject.payment_description
				self.order_number = payment_subject.id
				self.channel = Payment.payment_type_to_channel(payment_subject.payment_type)
				self.customer = OpenStruct.new({
					firstname: payment_subject.payment_customer_name ? payment_subject.payment_customer_name[:firstname] : nil,
					lastname: payment_subject.payment_customer_name ? payment_subject.payment_customer_name[:lastname] : nil,
					email: payment_subject.payment_customer_email,
				})
				return self
			end

		protected

			#
			# Translate locale to currency identifier used in GoPay system
			#
			def self.locale_to_currency(locale)
				locale_to_currency = {
					"cs" => "CZK",
					"sk" => "EUR",
				}
				return locale_to_currency[locale.to_s] if locale_to_currency[locale.to_s]
				return Config.default_currency
			end

			#
			# Translate payment type to channel identifier used in GoPay system
			#
			def self.payment_type_to_channel(payment_type)
				payment_type_to_channel = {
					"card" => "eu_gp_u",
					"bank" => "eu_bank",
				}
				return payment_type_to_channel[payment_type.to_s] if payment_type_to_channel[payment_type.to_s]
				return nil
			end

		end
	end
end