# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

RicAcl::Engine.routes.draw do

	# Privileges
	resources :privileges, only: [:index, :new, :edit] 

end