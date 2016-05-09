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
					has_many :receivers, class_name: RicNotification.user_model.to_s, through: :notification_receivers, source: :user

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

					after_save :set_receiver_after_save

				end

				module ClassMethods

					# *********************************************************
					# Interface
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
								message_text = I18n.t("notifications.automatic_messages.#{message_text.to_s}")
							end

							# Message params
							# TODO

							# Store
							notification.message = message_text

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
							# Store
							# *************************************************

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

							# Filter users
							receivers = receivers.delete_if { |receiver| !receiver.is_a?(RicNotification.user_model) }

							# Store
							notification.receivers = receivers

						end

						# Enqueue for delivery
						notification.enqueue_for_delivery

						return notification
					end

					#
					# Deliver notification to receivers by all configured methods
					#
					def deliver(id)
						config(:delivery_methods).each do |delivery_method|
							method("deliver_by_#{delivery_method}".to_sym).call(id)
						end
					end

					#
					# Deliver notification to receivers by email
					#
					def deliver_by_email(id)
						notification = RicNotification.notification_model.find_by_id(id)
						notification.notification_receivers.each do |notification_receiver|
							notification_receiver.deliver_by_email(notification)
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
				# (First) receiver TODO TEMP
				# *************************************************************

				def receiver_id=(new_receiver_id)
					@receiver_id_was = @receiver_id
					@receiver_id = new_receiver_id
				end

				def receiver_id
					if @receiver_id
						return @receiver_id
					elsif self.receivers.first
						return self.receivers.first.id
					else
						return nil
					end
				end

				def receiver
					return self.receivers.first
				end

			protected

				# *************************************************************
				# (First) receiver TODO TEMP
				# *************************************************************

				def set_receiver_after_save
					if @receiver_id != @receiver_id_was
						self.receiver_ids = [@receiver_id]
					end
				end

			end
		end
	end
end