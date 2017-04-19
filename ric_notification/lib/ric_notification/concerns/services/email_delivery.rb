# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * E-mail delivery service
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Services
			module EmailDelivery extend ActiveSupport::Concern

				module ClassMethods

					def deliver_by_email(id)
						
						# Find object
						notification = RicNotification.notification_model.find_by_id(id)
						if notification.nil?
							return nil
						end

						QC.enqueue("#{self.to_s}.deliver_batch_by_email_and_enqueue", id)
					end

					def deliver_batch_by_email(id, batch_size = 10)

						# Find object
						notification = RicNotification.notification_model.find_by_id(id)
						if notification.nil?
							return nil
						end

						# Nothing to do
						if notification.sent_count == notification.receivers_count
							return 0
						end

						# Get batch of receivers prepared for send
						notification_receivers = notification.notification_receivers.where(sent_at: nil).limit(batch_size)
						
						# Send entire batch
						sent_counter = 0
						notification_receivers.each do |notification_receiver|
							if notification_receiver.deliver_by_email(notification)
								sent_counter += 1
							end
						end

						# Update statistics
						notification.sent_count += sent_counter
						if notification.sent_count == notification.receivers_count
							notification.sent_at = Time.current
						end

						# Save
						notification.save

						return (notification.receivers_count - notification.sent_count)
					end

					def deliver_batch_by_email_and_enqueue(id, batch_size = 10)

						# Send single batch
						remaining = deliver_batch_by_email(id, batch_size)
						if remaining.nil?
							return nil
						end

						# If still some receivers remaining, enqueue next batch
						if remaining > 0

							# Sleep for a while to prevent SMTP server overflow
							sleep 5 # seconds

							# Queue next batch
							QC.enqueue("#{self.to_s}.deliver_batch_by_email_and_enqueue", id, batch_size)
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