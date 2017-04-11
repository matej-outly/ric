# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

RicInmail::Engine.routes.draw do

	# Mailbox
	resources :messages, except: [:edit, :update]

end
