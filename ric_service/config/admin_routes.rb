# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 6. 10. 2015
# *
# *****************************************************************************

RicService::AdminEngine.routes.draw do

	# Services
	resources :services, controller: "admin_services" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

end
