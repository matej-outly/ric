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

RicAuth::PublicEngine.routes.draw do

	# Devise
	devise_scope :user do
	
		# Session
		resource :session, only: [], controller: "public_sessions", path: "" do
			get :new, path: "sign_in", as: "new"
			post :create, path: "sign_in"
			delete :destroy, path: "sign_out", as: "destroy"
		end

		# Registration
		#resource :registration, only: [:new, :create, :edit, :update, :destroy], controller: "public_registrations", path: "", path_names: { new: "sign_up" } do
		#	get :cancel
		#end
		resource :registration, only: [:new, :create], controller: "public_registrations", path: "", path_names: { new: "sign_up" } 

		# Password (reset)
		resource :password, only: [:new, :create, :edit, :update], controller: "public_passwords"

		# Confirmation
		#resource :confirmation, only: [:new, :create, :show], controller: "public_confirmations"
		resource :confirmation, only: [:new, :create], controller: "public_confirmations"

	end

	# Profile
	resource :profile, controller: "public_profiles", only: [:edit, :update] do

		# Password (profile)
		resource :password, controller: "public_profile_passwords", only: [:edit, :update]
	
	end

end