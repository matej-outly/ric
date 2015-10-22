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

RicNewsletter::PublicEngine.routes.draw do

	# Customers
	resources :customers, controller: "public_customers", only: [:index] do
		collection do
			get "newsletter_sign_up"
			post "newsletter_sign_up"
			get "newsletter_sign_out"
		end
	end

end
