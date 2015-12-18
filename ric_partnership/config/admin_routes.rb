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

RicPartnership::AdminEngine.routes.draw do

	# Partners
	resources :partners, controller: "admin_partners" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

end
