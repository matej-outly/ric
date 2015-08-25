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

	# Pictures
	resources :pictures, controller: "admin_pictures", only: [:show, :new, :edit, :create, :update, :destroy]

end
