# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

RicNotification::AdminEngine.routes.draw do

	# Notifications
	resources :notifications, controller: "admin_notifications", only: [:index, :show, :destroy] do
		member do 
			put "deliver"
		end
	end

	# Notification templates
	resources :notification_templates, controller: "admin_notification_templates", only: [:index, :show, :edit, :update]

end
