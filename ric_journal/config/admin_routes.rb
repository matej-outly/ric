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

RicJournal::AdminEngine.routes.draw do

	# Newies
	resources :newies, controller: "admin_newies"

	# Newies
	resources :newie_pictures, only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_newie_pictures"

	# Events
	resources :events, controller: "admin_events"

end