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

RicSettings::AdminEngine.routes.draw do

	# Settings
	resource :settings, only: [:show, :edit, :update], controller: "admin_settings" 
	
end
