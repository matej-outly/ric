# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification service
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Services
			module Notification extend ActiveSupport::Concern

				module ClassMethods

					def notify(content, receivers, options = {})

						# Object
						notification = RicNotification.notification_model.new

						RicNotification.notification_model.transaction do

							# Get subject, message and params
							subject, message, params = parse_content(content)

							if !message.blank?

								# Interpret params and store it in DB
								notification.message = interpret_params(message, params)
								notification.subject = interpret_params(subject, params)

								# Kind
								if options[:kind]
									notification.kind = options[:kind]
								end

								# Sender
								if options[:sender]
									notification.sender = options[:sender]
								end

								# URL
								if options[:url]
									notification.url = options[:url]
								end

								# Attachment
								if options[:attachment]
									notification.attachment = options[:attachment]
								end

								# Store
								notification.sent_count = 0
								notification.save

								# Get valid receivers
								receivers = parse_receivers(receivers)

								# Store
								receivers.each do |receiver|
									notification.notification_receivers.create(receiver: receiver)
								end
								notification.receivers_count = receivers.size
								notification.save

							else
								notification = nil # Do not create notification with empty message
							end

						end

						# Enqueue for delivery
						notification.enqueue_for_delivery if !notification.nil?

						return notification
					end

					def parse_content(content)
						
						# Arrayize
						if !content.is_a?(Array)
							content = [content]
						end

						# Check for empty
						if content.length == 0
							raise "Notification is incorrectly defined."
						end

						# Extract content definition and params
						content_def = content.shift
						params = content

						if content_def.is_a?(Symbol)

							notification_template = RicNotification.notification_template_model.where(key: content_def.to_s).first
							if notification_template # Message and subject from template
								message = notification_template.message
								subject = notification_template.subject
							else # Static message
								message = I18n.t("notifications.automatic.#{content_def.to_s}.message", default: "")
								subject = I18n.t("notifications.automatic.#{content_def.to_s}.subject", default: "")
							end

						elsif content_def.is_a?(Hash) # Defined by hash containing subject and message

							subject = content_def[:subject]
							message = content_def[:message]

						elsif content_def.is_a?(String)

							message = content_def

						else
							raise "Notification is incorrectly defined."
						end

						# First parameter is message (all other parameters are indexed from 1)
						params.unshift(message)

						return [subject, message, params]		
					end

					def parse_receivers(receivers)
						
						# Arrayize
						if !receivers.is_a?(Array)
							receivers = [receivers]
						end

						# Automatic receivers defined by string
						new_receivers = []
						receivers.each do |receiver|
							if receiver.is_a?(String) || receiver.is_a?(Symbol)
								key, params = RicUser.people_selector_model.decode_value(receiver.to_s)
								new_receivers.concat(RicUser.people_selector_model.people(key, params).to_a) # Use people selector to generate receivers
							else
								new_receivers << receiver
							end
						end
						receivers = new_receivers

						# Receivers responding to email or users
						new_receivers = []
						receivers.each do |receiver|
							if receiver.respond_to?(:email)
								new_receivers << receiver
							else
								if receiver.respond_to?(:user)
									new_receivers << receiver.user
								else
									if receiver.respond_to?(:users)
										new_receivers.concat(receiver.users.to_a)
									end
								end
							end
						end
						receivers = new_receivers

						# Filter not valid receivers if any
						receivers = receivers.delete_if { |receiver| !receiver.respond_to?(:email) }

						return receivers
					end

					#
					# Interpret params into given text
					#
					def interpret_params(text, params)
						return text.gsub(/%{[^{}]+}/) do |match|

							# Substitude all %1, %2, %3, ... to a form which can be evaluated
							template_to_eval = match[2..-2].gsub(/%([0-9]+)/, "params[\\1]")
							
							# Evaluate match
							begin
								evaluated_match = eval(template_to_eval)
							rescue
								evaluated_match = ""
							end

							# Result
							evaluated_match
						end
					end

				end

			end
		end
	end
end