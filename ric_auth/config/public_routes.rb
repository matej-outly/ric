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

	# Registration
	#get "sign_up", to: "public_registrations#new", as: "new_registration"
	#post "sign_up", to: "public_registrations#create", as: "registration"
	
	# Session
	#get "sign_in", to: "public_sessions#new", as: "new_session"
	#post "sign_in", to: "public_sessions#create", as: "session"
	#delete "sign_out", to: "public_sessions#destroy", as: "destroy_session"

	# User
	resource :account, controller: "public_accounts", only: [:edit, :update]

	# Password
	resource :password, controller: "public_passwords", only: [:new, :create, :edit, :update]

end