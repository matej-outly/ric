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
				module Inmail extend ActiveSupport::Concern

				protected
				
					#
					# Send notification by InMail
					#
					def deliver_by_inmail
						notification = self.notification_delivery.notification

						# Send
						if defined?(RicInmail)
							RicInmail.receive(
								subject: notification.subject,
								message: notification.message,
								sender: notification.sender,
								receiver: self.receiver
							)
							self.state = "sent"
						else
							self.state = "error"
							self.error_message = "RicInmail not included."
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