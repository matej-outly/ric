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

RicTagging::Engine.routes.draw do
	
	# Tags
	resources :tags, only: [:create, :update, :destroy] do
		collection do
			get :search
		end
	end

end