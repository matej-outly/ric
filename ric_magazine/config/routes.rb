# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

RicMagazine::Engine.routes.draw do

	#
	# Admin
	#
	namespace :admin do
		
		# Articles
		resources :articles

	end

end
