# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

RicPaymentGopay::PublicEngine.routes.draw do

	# Payments
	resources :payments, controller: "public_payments", only: [] do
		member do
			get "new"
			get "done"
		end
	end

end