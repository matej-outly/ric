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

					has_many :notification_receivers, class_name: RicNotification.notification_receiver_model.to_s, dependent: :destroy
					belongs_to :sender, polymorphic: true
					
					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, [:notice, :alert, :warning], default: :notice

				end

				module ClassMethods

					# *********************************************************
					# Notification
					# *********************************************************

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
								message = I18n.t("notifications.automatic.#{message_text.to_s}.message", default: "")
								subject = I18n.t("notifications.automatic.#{message_text.to_s}.subject", default: "")
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

					#
					# Check if object is valid receiver
					# 
					def valid_receiver?(receiver)
						return false if !receiver.respond_to?(:email)
						return true
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
					# Delivery - inmail
					# *********************************************************

					# TODO: statistics and state should be different for email and inmail

					def deliver_by_inmail(id)

						# Find object
						notification = self.find_by_id(id)
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
				end

				#
				# Enqueue for delivery
				#
				def enqueue_for_delivery
					QC.enqueue("#{RicNotification.notification_model.to_s}.deliver", self.id)
				end

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

			end
		end
	end
end