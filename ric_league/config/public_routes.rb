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

RicLeague::PublicEngine.routes.draw do

	# Teams
	resources :teams, controller: "public_teams", only: [:index, :show]

end