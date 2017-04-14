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

					belongs_to :notification, class_name: RicNotification.notification_model.to_s
					belongs_to :receiver, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :notification_id, :receiver_id, :receiver_type

					# *********************************************************
					# State
					# *********************************************************

					enum_column :state, [:created, :sent, :received, :accepted, :error], default: :created
					
				end

				# *************************************************************
				# Receiver
				# *************************************************************

				#
				# Get name or email in case name is not set
				#
				def receiver_name_or_email
					if self.receiver
						if self.receiver.respond_to?(:name_formatted) && !self.receiver.name_formatted.blank?
							return self.receiver.name_formatted
						elsif self.receiver.respond_to?(:name) && !self.receiver.name.blank?
							return self.receiver.name
						else
							return self.receiver.email
						end
					else
						return nil
					end
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

				#
				# Send given notification by InMail
				#
				def deliver_by_inmail(notification)
					if notification.nil?
						return false
					end

					# Send
					if defined?(RicInmail)
						RicInmail.receive(
							subject: notification.subject,
							message: notification.message,
							sender: notification.sender,
							receiver: self.receiver
						)
						#self.state = "sent"
					else
						#self.state = "error"
						#self.error_message = "RicInmail not included."
					end

					# Mark as sent
					#self.sent_at = Time.current

					# Save
					#self.save

					return true
				end

			end
		end
	end
end