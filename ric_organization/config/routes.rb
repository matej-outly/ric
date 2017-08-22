# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

RicOrganization::Engine.routes.draw do

	# Organizations
	resources :organizations, only: [:index, :create, :update, :destroy] do
		collection do 
			post :filter
		end
	end

end
