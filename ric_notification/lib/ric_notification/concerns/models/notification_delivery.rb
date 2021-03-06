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
			module NotificationDelivery extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :notification, class_name: RicNotification.notification_model.to_s
					has_many :notification_receivers, class_name: RicNotification.notification_receiver_model.to_s, dependent: :destroy

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :notification_id, :kind

					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, RicNotification.delivery_kinds
					
					# *********************************************************
					# Queue kind
					# *********************************************************

					enum_column :policy, [
						:instantly,
						:batch
					]
					
				end

				# *************************************************************
				# Policy
				# *************************************************************

				def policy
					return case self.kind.to_sym
						when :email then :batch
						when :sms then :batch
						when :mailboxer then :instantly
						else :instantly
					end
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

				# *************************************************************
				# Service
				# *************************************************************

				#
				# Deliver by correct policy
				#
				def deliver
					self.class.deliver(self.id)
				end

				module ClassMethods

					#
					# Deliver by correct policy
					#
					def deliver(notification_delivery_id)
						
						# Find notification delivery object
						notification_delivery = RicNotification.notification_delivery_model.find_by_id(notification_delivery_id)
						return nil if notification_delivery.nil?

						# "Instanly" policy
						if notification_delivery.policy == :instantly
							self.deliver_instantly(notification_delivery_id)

						# "Batch" policy
						elsif notification_delivery.policy == :batch
							QC.enqueue("#{self.to_s}.deliver_batch_and_enqueue", notification_delivery_id)
						else
							return nil
						end

						return notification_delivery
					end

				end

			end
		end
	end
end