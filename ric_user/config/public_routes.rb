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

RicUser::PublicEngine.routes.draw do

	# Users
	resources :users, controller: "public_users", only: [:index, :show] do
		collection do
			get "search"
		end
	end

	# Session
	resource :session, controller: "public_session", only: [:show, :edit, :update]

	# People selectors
	resources :people_selectors, controller: "public_people_selectors", only: [] do
		collection do
			get "search"
		end
	end

end