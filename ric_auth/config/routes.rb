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

RicAuth::Engine.routes.draw do

	# Devise
	devise_scope :user do
	
		# Session
		resource :session, only: [], controller: "sessions", path: "" do
			get :new, path: "sign_in", as: "new"
			post :create, path: "sign_in"
			delete :destroy, path: "sign_out", as: "destroy"
		end

		# Registration
		resource :registration, only: [:new, :create], controller: "registrations", path: "", path_names: { new: "sign_up" } 

		# Password (reset)
		resource :password, only: [:new, :create, :edit, :update], controller: "passwords"

		# Confirmation
		resource :confirmation, only: [:new, :create, :show], controller: "confirmations"

	end

	# Profile
	resource :profile, controller: "profiles", only: [:show, :edit, :update] do

		# Password (profile)
		resource :password, controller: "profile_passwords", only: [:edit, :update]
	
	end

	# Overrides
	resources :overrides, only: [:create]

	# Authentications
	get "/:provider", to: "authentications#new", as: "sign_in_with_provider" # NEW action does't exist in this case because this request will be handled by OmniAuth middleware. Defined only for path helper.
	get "/:provider/callback", to: "authentications#create"
	delete "/:provider", to: "authentications#destroy"

end