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

RicReference::AdminEngine.routes.draw do

	# References
	resources :references, controller: "admin_references" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

end
