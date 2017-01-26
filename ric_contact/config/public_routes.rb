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

RicContact::PublicEngine.routes.draw do

	# Contact messages
	if RicContact.enable_contact_messages
		resources :contact_messages, controller: "public_contact_messages", only: [:create]
	end
	
end