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

require_dependency "ric_notification/application_controller"

module RicNotification
	class NotificationsController < ApplicationController
		include RicNotification::Concerns::Controllers::NotificationsController
	end
end

