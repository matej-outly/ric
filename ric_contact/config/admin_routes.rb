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
	
	# Contact messages
	if RicContact.enable_contact_messages && RicContact.save_contact_messages_to_db
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
