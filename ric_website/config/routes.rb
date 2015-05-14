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

RicWebsite::AdminEngine.routes.draw do

	# Texts
	resources :texts, controller: "admin/texts"

end

RicWebsite::PublicEngine.routes.draw do

	# Texts
	resources :texts, only: [:show], controller: "public/texts"

end