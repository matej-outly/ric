# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment subject (to be included to Order model or matching structure)
# *
# * Author: Matěj Outlý
# * Date  : 20. 2. 2016
# *
# *****************************************************************************

module RicPayment
	module Concerns
		module Models
			module PaymentSubject extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# State
					# *********************************************************

					enum_column :payment_state, ["paid", "in_progress", "not_paid"]

					#
					# Define additional methods to JSON export
					#
					add_methods_to_json [:payment_state]

				end

				module ClassMethods
					
					# *********************************************************
					# Scopes
					# *********************************************************

					def payment(payment)
						where(payment_id: payment.id)
					end

					# *************************************************************
					# Actions
					# *************************************************************

					#
					# Pay for the order, finalize action by:
					# - Sending notification e-mail
					#
					def pay_finalize(payment_subject_id)

						payment_subject = RicPayment.payment_subject_model.find_by_id(payment_subject_id)
						if !payment_subject
							return false
						end

						# Stop if not paid
						if !payment_subject.paid?
							return false
						end

						# Send payment email TODO
						if RicPayment.send_payment_finalize_mail == true
							begin
								RicPayment.payment_subject_mailer.payment(payment_subject).deliver_now
							rescue Net::SMTPFatalError, Net::SMTPSyntaxError
							end
						end

						# Log
						Rails.logger.info("payment_subject#pay_finalize: #{RicPayment.payment_subject_model.to_s}.id=" + payment_subject.id.to_s + ": Payment finalized")

						return true

					end

				end

				# *************************************************************
				# Actions
				# *************************************************************

				def initialize_payment(payment)
					
					# Already in progress
					if payment_in_progress?
						return false
					end

					# Save payment id 
					self.payment_id = payment.id
					self.override_accept_terms
					if !self.save
						return false
					end

					return true
				end

				#
				# Pay for the order
				#
				def pay
					
					# Paid at
					self.paid_at = Time.current

					# Delete payment id
					#self.payment_id = nil

					# Save
					self.override_accept_terms
					if !self.save
						return false
					end

					# Finalization
					if RicPayment.finalize_payment_in_background == true
						QC.enqueue("(RicPayment.payment_subject_model.to_s}.pay_finalize", self.id) # TODO some bugs may be in QC -> should be checked before use
					else
						RicPayment.payment_subject_model.pay_finalize(self.id) 
					end

					# Log
					Rails.logger.info("payment_subject#pay: #{RicPayment.payment_subject_model.to_s}.id=" + self.id.to_s + ": Paid and finalization enqueued")

					return true
				end

				#
				# Cancel payment in progress
				#
				def cancel_payment

					# Delete payment id
					self.payment_id = nil
					
					# Save
					self.override_accept_terms
					if !self.save
						return false
					end

					return true
				end

				# *************************************************************
				# State
				# *************************************************************

				#
				# Payment state
				#
				def payment_state
					return "paid" if paid?
					return "in_progress" if payment_in_progress?
					return "not_paid"
				end

				#
				# Is already paid?
				#
				def paid?
					return !self.paid_at.nil?
				end

				#
				# Is some payment in progress?
				#
				def payment_in_progress?
					return !self.payment_id.nil?
				end

				#
				# Is locked for editing?
				#
				def locked?
					return payment_in_progress? || paid?
				end

				# *************************************************************
				# Attributes for gateway (to be overriden)
				# *************************************************************

				#
				# Description for payment gateway
				#
				def payment_description
					return nil
				end

				#
				# Total amount of money to pay via gateway
				#
				def payment_price
					return self.price
				end

				#
				# Tax included in total price
				#
				def payment_price_tax
					return nil
				end

				#
				# Shipping included in total price
				#
				def payment_price_shipping
					return nil
				end

				#
				# Discount included in total price
				#
				def payment_price_discount
					return nil
				end

				#
				# Currency (as locale code) used for payment
				#
				def payment_currency
					return "cs"
				end

				#
				# Items for payment gateway
				#
				def payment_items
					return self.order_items
				end

				#
				# Customer name for payment gateway
				#
				def payment_customer_name
					if self.customer_name.is_a?(String)
						parsed_name = self.class.parse_name(self.customer_name)
						return {
							firstname: parsed_name[1],
							lastname: parsed_name[2],
						}
					else
						return self.customer_name # We expect hash containing :firstname and :lastname keys
					end
				end

				#
				# Customer e-mail for payment gateway
				#
				def payment_customer_email
					return self.customer_email
				end

				#
				# Customer phone for payment gateway
				#
				def payment_customer_phone
					return self.customer_phone
				end

				#
				# Customer address (street, number, city, zipcode) for payment gateway
				#
				def payment_customer_address
					if self.billing_address.is_a?(String)
						parsed_address = self.class.parse_address(self.billing_address)
						return {
							street: parsed_address[3],
							number: parsed_address[4],
							city: parsed_address[2],
							zipcode: parsed_address[1]
						}
					else
						return self.billing_address # We expect hash containing :street, :number, :city and :zipcode keys
					end
				end

			end
		end
	end
end