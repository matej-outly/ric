# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

RicAuthAdmin::Engine.routes.draw do
	
	# Devise
	devise_scope :user do
	
		# Session
		resource :session, only: [], controller: "sessions", path: "" do
			get :new, path: "sign_in", as: "new"
			post :create, path: "sign_in"
			delete :destroy, path: "sign_out", as: "destroy"
		end
		
		# Password (reset)
		resource :password, only: [:new, :create, :edit, :update], controller: "passwords"
		
	end

	# Profile
	resource :profile, controller: "profiles", only: [:show, :edit, :update] do

		# Password (profile)
		resource :password, controller: "profile_passwords", only: [:edit, :update]
	
	end

end