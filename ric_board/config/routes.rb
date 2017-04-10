# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

RicBoard::Engine.routes.draw do

	resources :board_tickets, only: [:index] do
		member do
			put "close"
			get "follow"
		end
	end

end
