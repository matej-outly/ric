# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact message
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicContact
	module Concerns
		module Models
			module ContactMessage extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Callbacks
					# *********************************************************
					
					after_create :send_message

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :message

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = config(:attributes).map { |attribute| attribute[:name].to_sym }
						return result
					end

				end

				def send_message
					if !(defined?(RicNotification).nil?)
						
						# Send to receiver
						RicNotification.notify([:contact_message_created, self], :role_admin)

						# Send copy to author
						if RicContact.send_contact_messages_copy_to_author && self.respond_to?(:email) && !self.email.blank?
							RicNotification.notify([:contact_message_created, self], self.email)
						end
					else

						# Send to receiver and copy to author
						begin 
							RicContact.contact_message_mailer.new_message(self).deliver_now
						rescue Net::SMTPFatalError, Net::SMTPSyntaxError
						end

					end
				end

			end
		end
	end
end