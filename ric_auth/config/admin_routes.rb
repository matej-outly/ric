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

	# Session
	#get "sign_in", to: "admin_sessions#new", as: "new_session"
	#post "sign_in", to: "admin_sessions#create", as: "session"
	#delete "sign_out", to: "admin_sessions#destroy", as: "destroy_session"
	
	# User
	resource :account, controller: "admin_accounts", only: [:edit, :update]

	# Password
	resource :password, controller: "admin_passwords", only: [:new, :create, :edit, :update]

end