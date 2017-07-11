# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Common delivery service
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Services
			module Delivery extend ActiveSupport::Concern

				module ClassMethods

					#
					# Deliver notification (defined by ID) to receivers by all configured methods
					#
					def deliver(id)
						RicNotification.delivery_kinds.each do |delivery_kind|
							method("deliver_by_#{delivery_kind.to_s}".to_sym).call(id)
						end
					end

				end

			end
		end
	end
end