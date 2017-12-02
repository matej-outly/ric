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
				module Sms extend ActiveSupport::Concern

				protected
				
					#
					# Send notification by SMS
					#
					def deliver_by_sms
						notification = self.notification_delivery.notification

						# Send SMS
						if defined?(RicSms)
							begin
								RicSms.deliver(self.receiver.phone, notification.message.strip_tags)
								self.state = "sent"
							#rescue Net::SMTPFatalError, Net::SMTPSyntaxError
							rescue StandardError => e
								self.state = "error"
								self.error_message = e.message
							end
						else
							self.state = "error"
							self.error_message = "RicSms not included."
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