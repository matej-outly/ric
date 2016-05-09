# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification templates
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

require_dependency "ric_notification/admin_controller"

module RicNotification
	class AdminNotificationTemplatesController < AdminController
		include RicNotification::Concerns::Controllers::Admin::NotificationTemplatesController
	end
end
