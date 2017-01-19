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

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************
					
					attr_accessor :name, :email, :message

				end

				def save
					if !(defined?(RicNotification).nil?)
						RicNotification.notify([:contact_message_new_message, self], :role_admin)
					else
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
