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
	resources :advertisers, controller: "admin/advertisers"

	# Banners
	resources :banners, controller: "admin/banners"

end

RicAdvert::ObserverEngine.routes.draw do

	# Advertisers
	resources :advertisers, controller: "observer/advertisers", only: [:index, :show]

	# Banners
	resources :banners, controller: "observer/banners", only: [:show]

end

RicAdvert::PublicEngine.routes.draw do
		
	# Banners
	resources :banners, controller: "public/banners", only: [] do
		collection do
			get "get"
			get "click"
		end
	end

end
