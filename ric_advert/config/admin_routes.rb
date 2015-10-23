# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

RicAdvert::AdminEngine.routes.draw do
		
	# Advertisers
	resources :advertisers, controller: "admin_advertisers"

	# Banners
	resources :banners, controller: "admin_banners"

end
