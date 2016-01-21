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
	resources :notifications, controller: "admin_notifications" do
		member do 
			put "deliver"
		end
	end

end
