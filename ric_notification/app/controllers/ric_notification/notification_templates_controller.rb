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

require_dependency "ric_notification/application_controller"

module RicNotification
	class NotificationTemplatesController < ApplicationController
		include RicNotification::Concerns::Controllers::NotificationTemplatesController
	end
end
