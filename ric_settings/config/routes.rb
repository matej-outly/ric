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

RicSettings::Engine.routes.draw do

	# Settings
	resource :settings, only: [:show, :edit, :update]
	
end
