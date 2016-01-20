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

RicNotification::PublicEngine.routes.draw do

	# Notifications
	resources :notifications, controller: "public_notifications", only: [:index, :show]

end