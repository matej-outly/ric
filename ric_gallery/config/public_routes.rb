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

RicGallery::PublicEngine.routes.draw do

	# Gallery directories
	resources :galleries, controller: "public_gallery_directories", only: [:index, :show]

end