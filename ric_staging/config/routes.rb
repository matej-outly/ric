# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

RicStaging::Engine.routes.draw do
	
	# Stages
	resources :stages, only: [] do
		collection do 
			put :transit
		end
	end

end