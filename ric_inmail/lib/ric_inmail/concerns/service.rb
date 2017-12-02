# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Delivery service
# *
# * Author: Matěj Outlý
# * Date  : 12. 4. 2017
# *
# *****************************************************************************

module RicInmail
	module Concerns
		module Service extend ActiveSupport::Concern

			module ClassMethods

				#
				# Send created InMessage to its receivers
				#
				def deliver(in_message)

					if !defined?(RicNotification)
						return false
					end

					RicInmail.in_message_model.transaction do

						# Deliver via RicNotification
						RicNotification.notify({
							subject: in_message.subject,
							message: in_message.message,
						}, in_message.receivers.to_a, {
							sender: in_message.sender
						})

						# Move to outbox and change message state
						in_message.delivery_state = :sent
						in_message.folder = :outbox
						in_message.save

					end

					return true
				end

				#
				# Receive new message to the delivery service defined by params
				#
				def receive(params = {})
					
					# Subject
					subject = params[:subject]
					
					# Message
					message = params[:message]
					
					# Sender
					sender = params[:sender]

					# Receiver
					receiver = params[:receiver]
					return false if receiver.nil?

					# Create and setup InMessage
					in_message = RicInmail.in_message_model.create(
						subject: subject,
						message: message,
						sender: sender,
						owner: receiver,
						folder: :inbox,
						delivery_state: :received,
					)

					return true
				end

			end

		end
	end
end
				