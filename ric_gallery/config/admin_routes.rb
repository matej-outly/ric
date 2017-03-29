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

	# Gallery directories
	resources :gallery_directories, controller: "admin_gallery_directories" do
		member do
			put "move_up"
			put "move_down"
		end
	end

	# Gallery pictures
	resources :gallery_pictures, controller: "admin_gallery_pictures", except: [:index, :show] do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

end
