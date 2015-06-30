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
	resources :branches, controller: "admin_branches"

	# Contact messages
	resources :contact_messages, controller: "admin_contact_messages"

end

RicContact::PublicEngine.routes.draw do

	# Contact messages
	resources :contact_messages, controller: "pulic_contact_messages", only: [:create]

end