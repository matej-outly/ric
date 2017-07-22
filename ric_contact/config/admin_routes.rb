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
	if RicContact.save_contact_messages_to_db
		resources :contact_messages, controller: "admin_contact_messages"
	end

end
