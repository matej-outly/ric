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
				# Payment state
				#
				def payment_state
					return "paid" if paid?
					return "in_progress" if payment_in_progress?
					return "not_paid"
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