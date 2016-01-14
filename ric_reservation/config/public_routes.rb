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

RicReservation::PublicEngine.routes.draw do

	# Timetables
	resources :timetables, only: [:index, :show], controller: "public_timetables"

	# Resource reservations
	resources :resource_reservations, except: [:index], controller: "public_resource_reservations"

end
