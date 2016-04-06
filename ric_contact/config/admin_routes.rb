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

RicContact::AdminEngine.routes.draw do

	# Branches
	if RicContact.enable_branches
		resources :branches, controller: "admin_branches"
	end
	
	# Contact messages
	if RicContact.enable_contact_messages
		resources :contact_messages, controller: "admin_contact_messages"
	end

	# Contact people
	if RicContact.enable_contact_people
		resources :contact_people, controller: "admin_contact_people" do
			member do
				put "move/:relation/:destination_id", action: "move", as: "move"
			end
		end
	end

end
