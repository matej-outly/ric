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

RicAdvert::Engine.routes.draw do

	#
	# Public
	#
	namespace :public do
		
		# Banners
		get "banners/get/:kind", to: "banners#get", as: "banner_get"
		get "banners/click/:id", to: "banners#click", as: "banner_click"

	end

	#
	# Admin
	#
	namespace :admin do
		
		# Advertisers
		resources :advertisers

		# Banners
		resources :banners
	
	end

	#
	# Observer
	#
	namespace :observer do
		
		# Advertisers
		resources :advertisers, only: [:index, :show]

		# Banners
		resources :banners, only: [:show]
	
	end

end
