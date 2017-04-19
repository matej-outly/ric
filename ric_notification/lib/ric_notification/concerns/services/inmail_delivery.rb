# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Inmail delivery service
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

					# TODO: statistics and state should be different for email and inmail
					def deliver_by_inmail(id)

						# Find object
						notification = RicNotification.notification_model.find_by_id(id)
						if notification.nil?
							return nil
						end

						# Nothing to do
						#if notification.sent_count == notification.receivers_count
						#	return 0
						#end

						# Get batch of receivers prepared for send
						notification_receivers = notification.notification_receivers #.where(sent_at: nil)
						
						# Send entire batch
						#sent_counter = 0
						notification_receivers.each do |notification_receiver|
							if notification_receiver.deliver_by_inmail(notification)
								#sent_counter += 1
							end
						end

						# Update statistics
						#notification.sent_count += sent_counter
						#if notification.sent_count == notification.receivers_count
						#	notification.sent_at = Time.current
						#end

						# Save
						#notification.save

						#return (notification.receivers_count - notification.sent_count)
					end

				end

			end
		end
	end
end