# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

RicUser::Engine.routes.draw do

	# People selectors
	resources :people_selectors, only: [] do
		collection do
			get :search
		end
	end

end
