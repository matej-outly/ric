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
	if RicPartnership.enable_partners
		resources :partners, controller: "admin_partners" do
			member do
				put "move/:relation/:destination_id", action: "move", as: "move"
			end
		end
	end

	# References
	if RicPartnership.enable_references
		resources :references, controller: "admin_references" do
			member do
				put "move/:relation/:destination_id", action: "move", as: "move"
			end
		end
	end

end
