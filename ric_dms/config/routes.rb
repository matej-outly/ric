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

RicDms::Engine.routes.draw do

	# Folders
	resources :folders, only: [:index, :show, :new, :edit, :create, :update, :destroy] do

		# Documents
		resources :documents, only: [:show, :new, :edit, :create, :update, :destroy] do

			# Document versions
			resources :versions, only: [:destroy]

		end

	end	

end
