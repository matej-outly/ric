# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification template
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicNotification
	class NotificationTemplate < ActiveRecord::Base
		include RicNotification::Concerns::Models::NotificationTemplate
	end
end
