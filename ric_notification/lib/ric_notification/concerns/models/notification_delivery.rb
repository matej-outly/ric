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
			module NotificationReceiver extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
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

			end
		end
	end
end