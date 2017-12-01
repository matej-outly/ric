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
			module NotificationReceiver 
				module Sms extend ActiveSupport::Concern

				protected
				
					#
					# Send notification by SMS
					#
					def deliver_by_sms
						raise "Not implemented."

						# TODO link to correct SMS backend
					end

				end
			end
		end
	end
end