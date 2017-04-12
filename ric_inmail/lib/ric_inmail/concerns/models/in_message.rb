# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Internal Message
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicInmail
	module Concerns
		module Models
			module InMessage extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :owner, polymorphic: true
					belongs_to :sender, polymorphic: true
					
					# *********************************************************
					# Folder
					# *********************************************************

					enum_column :folder, [:inbox, :outbox, :archive, :drafts], default: :drafts

					# *********************************************************
					# Delivery state
					# *********************************************************

					state_column :delivery_state, [:created, :sent, :received], default: :created

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						return [
							:subject, 
							:message,
							:receivers_selector_values,
						]
					end

					# *********************************************************
					# Scopes
					# *********************************************************

					def owned_by(owner)
						where(owner: owner)
					end

				end

				# *************************************************************
				# Receivers
				# *************************************************************

				def receivers
					self.people
				end

				def receivers_selectors
					self.people_selectors
				end

				def receivers_selector_values
					self.people_selector_values
				end

				def receivers_selector_values=(values)
					self.people_selector_values = values
				end

				# *************************************************************
				# Lifecycle
				# *************************************************************

				def template=(template)
					self.subject = template.subject if template.respond_to?(:subject) && !template.subject.nil?
					self.message = template.message if template.respond_to?(:message) && !template.message.nil?
					self.receivers_selector_values = template.receivers_selector_values if template.respond_to?(:receivers_selector_values) && !template.receivers_selector_values.nil?
				end

				def read(flag = true)
					self.is_read = flag
					self.save
				end

				def flag(flag = true)
					self.is_flagged = flag
					self.save
				end

				def deliver
					RicInmail.deliver(self)
				end

			end
		end
	end
end