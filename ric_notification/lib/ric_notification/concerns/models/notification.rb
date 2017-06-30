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

					has_many :notification_deliveries, class_name: RicNotification.notification_delivery_model.to_s, dependent: :destroy
					belongs_to :sender, polymorphic: true
					
					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, [:notice, :alert, :warning], default: :notice

				end

				# *************************************************************
				# Delivery
				# *************************************************************

				#
				# Enqueue for delivery
				#
				def enqueue_for_delivery
					QC.enqueue("RicNotification.deliver", self.id)
				end

				# *************************************************************
				# Progress
				# *************************************************************

				def done
					sent_count = 0
					receivers_count = 0
					self.notification_deliveries.each do |notification_delivery|
						sent_count += notification_delivery.sent_count.to_i
						receivers_count += notification_delivery.receivers_count.to_i
					end
					return sent_count.to_s + "/" + receivers_count.to_s
				end

				# *************************************************************
				# Sender
				# *************************************************************

				#
				# Get name or email in case name is not set
				#
				def sender_name_or_email
					if self.sender
						if self.sender.respond_to?(:name_formatted) && !self.sender.name_formatted.blank?
							return self.sender.name_formatted
						elsif self.sender.respond_to?(:name) && !self.sender.name.blank?
							return self.sender.name
						else
							return self.sender.email
						end
					else
						return nil
					end
				end

			protected

			end
		end
	end
end