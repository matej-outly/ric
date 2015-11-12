# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

RicEshop::AdminEngine.routes.draw do

	# Orders
	resources :orders, controller: "admin_orders", except: [:new, :create]

end
