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