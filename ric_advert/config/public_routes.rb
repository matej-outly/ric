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

RicAdvert::PublicEngine.routes.draw do
		
	# Banners
	resources :banners, controller: "public_banners", only: [] do
		collection do
			get "get"
			get "click"
		end
	end

end