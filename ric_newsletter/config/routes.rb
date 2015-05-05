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

RicNewsletter::AdminEngine.routes.draw do

	# Newsletters
	resources :newsletters, controller: 'admin/newsletters'

	# Sent newsletters
	resources :sent_newsletters, controller: 'admin/sent_newsletters', only: [:new, :create, :destroy] do
		member do
			get 'resend'
		end
	end

end
