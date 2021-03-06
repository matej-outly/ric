# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification receiver
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Models
			module NotificationReceiver 
				module Email extend ActiveSupport::Concern

				protected
				
					#
					# Send notification by e-mail
					#
					def deliver_by_email
						notification = self.notification_delivery.notification

						# Send email
						begin 
							RicNotification::NotificationMailer.notify(notification, self.receiver).deliver_now
							self.state = "sent"
						#rescue Net::SMTPFatalError, Net::SMTPSyntaxError
						rescue StandardError => e
							self.state = "error"
							self.error_message = e.message
						end
					
						# Mark as sent
						self.sent_at = Time.current

						# Save
						self.save

						return true
					end

				end
			end
		end
	end
end