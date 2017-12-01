# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification receiver
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2017
# *
# *****************************************************************************

module RicNotification
	class NotificationDelivery < ActiveRecord::Base
		include RicNotification::Concerns::Models::NotificationDelivery
		include RicNotification::Concerns::Models::NotificationDelivery::Batch
		include RicNotification::Concerns::Models::NotificationDelivery::Instantly
	end
end