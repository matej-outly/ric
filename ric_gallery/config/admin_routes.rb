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
	resources :directories, controller: "admin_directories" do
		member do
			put "move_up"
			put "move_down"
		end
	end

	# Pictures
	resources :pictures, controller: "admin_pictures" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end
end
