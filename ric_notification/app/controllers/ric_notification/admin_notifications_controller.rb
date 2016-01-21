# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notifications
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

require_dependency "ric_notification/admin_controller"

module RicNotification
	class AdminNotificationsController < AdminController
		include RicNotification::Concerns::Controllers::Admin::NotificationsController
	end
end

