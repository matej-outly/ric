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

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :notification_delivery, class_name: RicNotification.notification_delivery_model.to_s
					belongs_to :receiver, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :notification_delivery_id, :receiver_id, :receiver_type

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
				# Send notification by valid delivery kind
				#
				def deliver
					return self.send("deliver_by_#{self.notification_delivery.kind}")
				end

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

				#
				# Send notification by SMS
				#
				def deliver_by_sms
					raise "Not implemented."

					# TODO link to correct SMS backend
				end

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