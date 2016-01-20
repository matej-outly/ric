# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notifications
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_notification/public_controller"

module RicNotification
	class PublicNotificationsController < PublicController
		include RicNotification::Concerns::Controllers::Public::NotificationsController
	end
end
