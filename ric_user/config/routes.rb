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
	resources :roles, only: [:index, :create, :update, :destroy] do
		collection do
			post :filter
			get :search
		end
	end

	# Users
	resources :users, only: [:index, :show, :create, :update, :destroy] do
		collection do
			post :filter
			get :search
		end
		member do
			get :lock
			put :lock
			get :unlock
			put :unlock
			get :confirm
			put :confirm
		end

		# User passwords
		resource :password, controller: :user_passwords, only: [:edit, :update] do
			member do
				get :regenerate
				put :regenerate
			end
		end

	end

	# Session
	resource :session, only: [:show, :edit, :update]

end
