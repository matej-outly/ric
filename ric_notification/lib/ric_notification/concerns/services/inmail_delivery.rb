# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * InMail delivery service
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Services
			module InmailDelivery extend ActiveSupport::Concern

				module ClassMethods

					def deliver_by_inmail(id)

						# Find notification object
						notification = RicNotification.notification_model.find_by_id(id)
						return nil if notification.nil?
						
						# Find delivery object
						notification_delivery = notification.notification_deliveries.where(kind: "inmail").first
						return nil if notification_delivery.nil?

						# Nothing to do
						return 0 if notification_delivery.sent_count == notification_delivery.receivers_count
						
						# Get batch of receivers prepared for send
						notification_receivers = notification_delivery.notification_receivers #.where(sent_at: nil)
						
						# Send entire batch
						sent_counter = 0
						notification_receivers.each do |notification_receiver|
							sent_counter += 1 if notification_receiver.deliver
						end

						# Update statistics
						notification_delivery.sent_count += sent_counter
						notification_delivery.sent_at = Time.current if notification_delivery.sent_count == notification_delivery.receivers_count
						
						# Save
						notification_delivery.save

						return (notification_delivery.receivers_count - notification_delivery.sent_count)
					end

				end

			end
		end
	end
end