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

RicGallery::AdminEngine.routes.draw do

	# Directories
	resources :directories, controller: "admin_directories"

	# Images
	resources :images, controller: "admin_images", only: [:show, :new, :edit, :create, :update, :destroy]

end

RicGallery::PublicEngine.routes.draw do

	# Directories
	resources :directories, controller: "public_directories", only: [:index, :show]

end