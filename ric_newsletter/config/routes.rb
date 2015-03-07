# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

RicNewsletter::Engine.routes.draw do

	#
	# Admin
	#
	namespace :admin do
		
		# Newsletters
		resources :newsletters

	    # Sent newsletters
	    resources :sent_newsletters, only: [:new, :create, :destroy] do
	    	member do
	    		get 'resend'
	    	end
	    end

	end

end
