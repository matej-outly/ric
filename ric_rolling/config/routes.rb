# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

RicRolling::Engine.routes.draw do

	# Sessions
	get "sign_in", to: "sessions#new", as: :sign_in
	post "sign_in", to: "sessions#create"
	delete "sign_out", to: "sessions#destroy", as: :sign_out
	
	# Registrations
	get "sign_up", to: "registrations#new", as: :sign_up
	post "sign_up", to: "registrations#create"

end
