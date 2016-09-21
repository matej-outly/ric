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
			module NotificationReceiver extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to notification
					#
					belongs_to :notification, class_name: RicNotification.notification_model.to_s

					#
					# Relation to receiver
					#
					belongs_to :receiver, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present
					#
					validates_presence_of :notification_id, :receiver_id, :receiver_type

					# *********************************************************
					# State
					# *********************************************************

					#
					# State
					#
					enum_column :state, ["created", "sent", "received", "accepted", "error"], default: "created"
					
				end

				# *************************************************************
				# Delivery
				# *************************************************************

				#
				# Send given notification by email
				#
				def deliver_by_email(notification)

					if notification.nil?
						return false
					end

					# Send email
					begin 
						RicNotification::NotificationMailer.notify(notification, self.receiver).deliver_now
						self.state = "sent"
					#rescue Net::SMTPFatalError, Net::SMTPSyntaxError
					rescue Exception => e
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