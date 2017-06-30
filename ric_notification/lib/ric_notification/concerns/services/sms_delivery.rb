# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * SMS delivery service
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2017
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Services
			module SmsDelivery extend ActiveSupport::Concern

				module ClassMethods

					def deliver_by_sms(id)
						
						# Find object
						notification = RicNotification.notification_model.find_by_id(id)
						return nil if notification.nil?

						QC.enqueue("#{self.to_s}.deliver_batch_by_sms_and_enqueue", id)
					end

					def deliver_batch_by_sms(id, batch_size = 10)

						# Find notification object
						notification = RicNotification.notification_model.find_by_id(id)
						return nil if notification.nil?

						# Find delivery object
						notification_delivery = notification.notification_deliveries.where(kind: "sms").first
						return nil if notification_delivery.nil?
						
						# Nothing to do
						return 0 if notification_delivery.sent_count == notification_delivery.receivers_count
						
						# Get batch of receivers prepared for send
						notification_receivers = notification_delivery.notification_receivers.where(sent_at: nil).limit(batch_size)
						
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

					def deliver_batch_by_sms_and_enqueue(id, batch_size = 10)

						# Send single batch
						remaining = deliver_batch_by_sms(id, batch_size)
						return nil if remaining.nil?

						# If still some receivers remaining, enqueue next batch
						if remaining > 0

							# Sleep for a while to prevent SMS service overflow
							sleep 5 # seconds

							# Queue next batch
							QC.enqueue("#{self.to_s}.deliver_batch_by_sms_and_enqueue", id, batch_size)
							return false
						else
							return true
						end

					end

				end

			end
		end
	end
end