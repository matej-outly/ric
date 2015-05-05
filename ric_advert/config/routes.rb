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
	get "banners/get/:kind", to: "public/banners#get", as: "banner_get"
	get "banners/click/:id", to: "public/banners#click", as: "banner_click"

end
