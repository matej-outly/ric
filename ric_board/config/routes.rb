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

	# Board
	resource :board, only: [:show] do
		
		# Tickets
		resources :tickets, controller: "board_tickets", only: [] do
			member do
				put "close"
			end
		end

	end

end
