# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 27. 4. 2015
# *
# *****************************************************************************

RicAdmin::Engine.routes.draw do

	# Public pages
	get "public/terms"
	get "public/accessibility"
	get "public/help"
	get "public/contact"

end