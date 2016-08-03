# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

RicSeason::AdminEngine.routes.draw do

	# Seasons
	resources :seasons, controller: "admin_seasons" do
		collection do
			get "search"
		end
		member do
			put "make_current"
		end
	end

end
