# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

RicPaymentFerbuy::PublicEngine.routes.draw do

	# Payments
	resources :payments, controller: "public_payments", only: [] do
		member do
			get "new"
			get "success"
			get "failed"
		end
	end

end