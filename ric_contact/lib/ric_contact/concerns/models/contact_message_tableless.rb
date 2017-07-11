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
			module ContactMessageTableless extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Config
					# *********************************************************

					self.config = RugRecord::Config.new(self)

					# *********************************************************
					# Structure
					# *********************************************************
					
					if config(:attributes)
						config(:attributes).each do |attribute|
							attr_accessor attribute[:name]
						end
					end

					# *********************************************************
					# Validators
					# *********************************************************
					
					if config(:attributes)
						config(:attributes).each do |attribute|
							if attribute[:required] == true
								validates_presence_of attribute[:name]
							end
						end
					end

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
				
				def id
					return 1
				end

				def save
					if valid?
						if !(defined?(RicNotification).nil?)

							# Send to receiver
							RicNotification.notify([:contact_message_created, self], :role_admin)

							if self.respond_to?(:email) && !self.email.blank?

								# Send copy to author
								if RicContact.send_contact_messages_copy_to_author
									RicNotification.notify([:contact_message_created, self], self.email)
								end

								# Send notification to author
								if RicContact.send_contact_messages_notification_to_author
									RicNotification.notify([:contact_message_notification, self], self.email)
								end

							end
						else

							# Send to receiver (and copy to author if configured)
							begin 
								RicContact.contact_message_mailer.new_message(self).deliver_now
							rescue Net::SMTPFatalError, Net::SMTPSyntaxError
							end

							# Send notification to author if configured
							if self.respond_to?(:email) && !self.email.blank?
								if RicContact.send_contact_messages_notification_to_author
									begin 
										RicContact.contact_message_mailer.notify_message(self).deliver_now
									rescue Net::SMTPFatalError, Net::SMTPSyntaxError
									end
								end
							end

						end
						return true
					else
						return false
					end
				end

			end
		end
	end
end
