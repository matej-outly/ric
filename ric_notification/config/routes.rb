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

RicNotification::Engine.routes.draw do

	# Notifications
	resources :notifications, only: [:index, :show, :destroy] do
		member do 
			put :deliver
		end
	end

	# Notification templates
	resources :notification_templates, only: [:index, :edit, :update]

end
