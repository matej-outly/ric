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

	# Documents
	resources :documents, only: [:show, :new, :create, :destroy]

	# Document versions
	resources :document_versions, only: [:destroy]

	# Directory listing
	resources :document_folders, only: [:index, :show, :new, :create, :destroy]

end
