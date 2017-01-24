# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Models
			module Notification extend ActiveSupport::Concern

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
					# Relation to users
					#
					has_many :notification_receivers, class_name: RicNotification.notification_receiver_model.to_s, dependent: :destroy
					
					#
					# Relation to user
					#
					belongs_to :author, class_name: RicNotification.user_model.to_s
					
					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, ["notice", "alert", "warning"], default: "notice"

					# *********************************************************
					# (First) receiver TODO TEMP
					# *********************************************************

					#after_save :set_receiver_after_save

				end

				module ClassMethods

					# *********************************************************
					# Notification
					# *********************************************************

					#
					# Notify
					#
					def notify(message, receivers, options = {})

						notification = RicNotification.notification_model.new

						RicNotification.notification_model.transaction do

							# *************************************************
							# Message
							# *************************************************

							# Arrayize
							if !message.is_a?(Array)
								message = [message]
							end

							# Check for empty
							if message.length == 0
								raise "Message is empty."
							end

							# Extract message text and params
							message_text = message.shift
							message_params = message

							# Automatic message
							if message_text.is_a?(Symbol)
								
								notification_template = RicNotification.notification_template_model.where(key: message_text.to_s).first
								if notification_template

									# Message and subject from template
									message_text = notification_template.message
									subject = notification_template.subject

								else

									# Static message
									message_text = I18n.t("notifications.automatic_messages.#{message_text.to_s}", default: "")
									subject = nil

								end
							end

							# First parameter is message text (all other parameters are indexed from 1)
							message_params.unshift(message_text)

							if !message_text.blank?

								# Interpret params and store it in DB
								notification.message = interpret_params(message_text, message_params)
								notification.subject = subject

								# *************************************************
								# Kind
								# *************************************************

								if options[:kind]
									notification.kind = options[:kind]
								end

								# *************************************************
								# Author
								# *************************************************

								if options[:author] && options[:author].is_a?(RicNotification.user_model)
									notification.author_id = options[:author].id
								end

								# *************************************************
								# URL
								# *************************************************

								if options[:url]
									notification.url = options[:url]
								end

								# *************************************************
								# Attachment
								# *************************************************

								if options[:attachment]
									notification.attachment = options[:attachment]
								end

								# *************************************************
								# Store
								# *************************************************

								notification.sent_count = 0
								notification.save

								# *************************************************
								# Receivers
								# *************************************************

								# Arrayize
								if !receivers.is_a?(Array)
									receivers = [receivers]
								end

								# Automatic receivers
								automatic_receivers = []
								receivers.each do |receiver|
									if receiver.is_a?(Symbol) || receiver.is_a?(String)
										if receiver.to_s == "all"
											automatic_receivers.concat(RicNotification.user_model.all)
										elsif receiver.to_s.start_with?("role_")
											automatic_receivers.concat(RicNotification.user_model.where(role: receiver.to_s[5..-1]))
										end
									end
								end
								receivers.concat(automatic_receivers)

								# Filter receivers
								receivers = receivers.delete_if { |receiver| !valid_receiver?(receiver) }

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

					# *********************************************************
					# Delivery - common
					# *********************************************************

					#
					# Deliver notification to receivers by all configured methods
					#
					def deliver(id)
						config(:delivery_methods).each do |delivery_method|
							method("deliver_by_#{delivery_method}".to_sym).call(id)
						end
					end

					# *********************************************************
					# Delivery - e-mail
					# *********************************************************

					def deliver_by_email(id)
						
						# Find object
						notification = self.find_by_id(id)
						if notification.nil?
							return nil
						end

						
						QC.enqueue("#{RicNotification.notification_model.to_s}.deliver_batch_by_email_and_enqueue", id)
					end

					def deliver_batch_by_email(id, batch_size = 10)

						# Find object
						notification = self.find_by_id(id)
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
							QC.enqueue("#{RicNotification.notification_model.to_s}.deliver_batch_by_email_and_enqueue", id, batch_size)
							return false
						else
							return true
						end

					end

					#
					# Check if object is valid receiver
					# 
					def valid_receiver?(receiver)
						return false if !receiver.respond_to?(:email)
						return false if !receiver.respond_to?(:name_or_email)
						return true
					end

				end

				#
				# Enqueue for delivery
				#
				def enqueue_for_delivery
					QC.enqueue("#{RicNotification.notification_model.to_s}.deliver", self.id)
				end

				# *************************************************************
				# (First) receiver TODO TEMP
				# *************************************************************

#				def receiver_id=(new_receiver_id)
#					@receiver_id_was = @receiver_id
#					@receiver_id = new_receiver_id
#				end#

#				def receiver_id
#					if @receiver_id
#						return @receiver_id
#					elsif self.receivers.first
#						return self.receivers.first.id
#					else
#						return nil
#					end
#				end#

#				def receiver
#					return self.receivers.first
#				end

				# *************************************************************
				# Progress
				# *************************************************************

				def done
					if self.sent_count && self.receivers_count
						return self.sent_count.to_s + "/" + self.receivers_count.to_s
					else
						return nil
					end
				end

			protected

				# *************************************************************
				# (First) receiver TODO TEMP
				# *************************************************************

#				def set_receiver_after_save
#					if @receiver_id != @receiver_id_was
#						self.receiver_ids = [@receiver_id]
#					end
#				end

			end
		end
	end
end