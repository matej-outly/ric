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
	class NotificationReceiver < ActiveRecord::Base
		include RicNotification::Concerns::Models::NotificationReceiver
		include RicNotification::Concerns::Models::NotificationReceiver::Email
		include RicNotification::Concerns::Models::NotificationReceiver::Sms
		include RicNotification::Concerns::Models::NotificationReceiver::Mailboxer
	end
end
