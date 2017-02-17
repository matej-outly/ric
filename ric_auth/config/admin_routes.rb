# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

RicAuth::AdminEngine.routes.draw do
	
	# Devise
	devise_scope :user do
	
		# Session
		resource :session, only: [], controller: "admin_sessions", path: "" do
			get :new, path: "sign_in", as: "new"
			post :create, path: "sign_in"
			delete :destroy, path: "sign_out", as: "destroy"
		end
		
		# Password (reset)
		resource :password, only: [:new, :create, :edit, :update], controller: "admin_passwords"
		
	end

	# Profile
	resource :profile, controller: "admin_profiles", only: [:edit, :update] do

		# Password (profile)
		resource :password, controller: "admin_profile_passwords", only: [:edit, :update]
	
	end

end