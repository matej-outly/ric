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

	# Events
	resources :events, controller: "admin_events"

end

RicJournal::PublicEngine.routes.draw do

	# Newies
	resources :newies, controller: "public_newies", only: [:index, :show]

	# Events
	resources :events, controller: "public_events", only: [:index, :show]

end