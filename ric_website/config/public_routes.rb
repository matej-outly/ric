# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

RicWebsite::PublicEngine.routes.draw do

	# Node attachments
	resources :node_attachments, only: [:show], controller: "public_node_attachments"

end