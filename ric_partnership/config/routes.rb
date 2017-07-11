# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 6. 10. 2015
# *
# *****************************************************************************

RicPartnership::Engine.routes.draw do

	# Partners
	resources :partners do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end
	
end
