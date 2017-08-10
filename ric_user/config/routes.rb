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

	# Roles
	resources :roles, only: [] do
		collection do
			get "search"
		end
	end

	# Users
	resources :users do
		collection do
			post "filter"
			get "search"
		end
		member do
			get "lock"
			put "lock"
			get "unlock"
			put "unlock"
			get "confirm"
			put "confirm"
		end
	end

	# User passwords
	resources :user_passwords, only: [:edit, :update] do
		member do
			get "regenerate"
			put "regenerate"
		end
	end

	# People selectors
	resources :people_selectors, only: [] do
		collection do
			get "search"
		end
	end

	# Session
	resource :session, only: [:show, :edit, :update]

end
