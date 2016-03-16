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
					# Relation to user
					#
					belongs_to :user, class_name: RicNotification.user_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present
					#
					validates_presence_of :notification_id, :user_id

					# *********************************************************
					# State
					# *********************************************************

					#
					# State
					#
					enum_column :state, ["created", "sent", "received", "accepted"], default: "created"
					
				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

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
						RicNotification::NotificationMailer.notify(notification, self.user).deliver_now
					rescue Net::SMTPFatalError, Net::SMTPSyntaxError
					end

					# Mark as sent
					self.sent_at = Time.current
					self.state = "sent"

					# Save
					self.save

					return true
				end

			end
		end
	end
end