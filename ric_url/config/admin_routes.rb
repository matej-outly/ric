# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

RicUrl::AdminEngine.routes.draw do

	# Slugs
	resources :slugs, controller: "admin_slugs", only: [:index, :new, :create, :edit, :update, :destroy] do
		collection do
			post "filter"
		end
	end
	
end
