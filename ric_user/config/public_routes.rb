# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

RicUser::PublicEngine.routes.draw do

	# Session
	resource :session, controller: "public_session", only: [:show, :edit, :update]

end