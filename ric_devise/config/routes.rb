# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

RicDevise::Engine.routes.draw do

	#
	# RIC Devise
	#
	devise_for :users, controllers: { sessions: "ric_devise/sessions", passwords: "ric_devise/passwords" }
	
end
