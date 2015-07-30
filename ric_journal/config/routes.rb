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

end

RicJournal::PublicEngine.routes.draw do

	# Newies
	resources :newies, controller: "pulic_newies", only: [:index, :show]

end