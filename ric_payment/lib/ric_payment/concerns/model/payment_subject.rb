# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Payment subject
# *
# * Author: Matěj Outlý
# * Date  : 20. 2. 2016
# *
# *****************************************************************************

module RicEshop
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
					# Enums
					# *********************************************************

					#
					# Payment state
					#
					enum_column :payment_state, [:paid, :in_progress, :not_paid]

					# *********************************************************
					# JSON
					# *********************************************************

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

				end

				# *************************************************************
				# Actions
				# *************************************************************

				def initialize_payment(payment)
					
					# Already in progress
					if payment_in_progress?
						return false
					end

					# Save payment session id 
					self.payment_id = payment.id
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
					self.payment_id = nil

					# Save
					if !self.save
						return false
					end

					# E-mail
					RicPayment.payment_subject_model.pay_finalize(self.id) # QC not working in this case
					#QC.enqueue("(RicPayment.payment_subject_model.to_s}.pay_finalize", self.id)

					# Log
					Rails.logger.info("payment_subject#pay: #{RicPayment.payment_subject_model.to_s}.id=" + self.id.to_s + ": Paid and finalization enqueued")

					return true
				end

				#
				# Pay for the order - finalize action by sending e-mail
				#
				def self.pay_finalize(payment_subject_id)

					payment_subject = RicPayment.payment_subject_model.find_by_id(payment_subject_id)
					if !payment_subject
						return false
					end

					# Stop if not paid
					if !payment_subject.paid?
						return false
					end

					# Send payment email TODO
					begin
						RicPayment.payment_subject_mailer.payment(payment_subject).deliver_now
					rescue Net::SMTPFatalError
					end

					# Log
					Rails.logger.info("payment_subject#pay_finalize: #{RicPayment.payment_subject_model.to_s}.id=" + payment_subject.id.to_s + ": Payment e-mail sent")

					return true

				end

				#
				# Cancel payment in progress
				#
				def cancel_payment

					# Delete payment id
					self.payment_id = nil
					
					# Save
					if !self.save
						return false
					end

					return true
				end

				# *************************************************************
				# Status
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
					return !self.payment_session_id.nil?
				end

				#
				# Is locked for editing?
				#
				def locked?
					return payment_in_progress? || paid?
				end

				#
				# Label for payment gateway
				#
				def payment_label
					""
				end

			end
		end
	end
end