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

RicAdvert::ObserverEngine.routes.draw do

	# Advertisers
	resources :advertisers, controller: "observer_advertisers", only: [:index, :show]

	# Banners
	resources :banners, controller: "observer_banners", only: [:show]

end

RicAdvert::PublicEngine.routes.draw do
		
	# Banners
	resources :banners, controller: "public_banners", only: [] do
		collection do
			get "get"
			get "click"
		end
	end

end
