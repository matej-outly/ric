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

RicAdvert::ObserverEngine.routes.draw do

	# Advertisers
	resources :advertisers, controller: "observer_advertisers", only: [:index, :show]

	# Banners
	resources :banners, controller: "observer_banners", only: [:show]

end
