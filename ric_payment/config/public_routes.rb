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

RicPayment::PublicEngine.routes.draw do

	# Payments
	resources :payments, controller: "public_payments", only: [:new, :create] do
		member do
			get "success"
			get "failed"
		end
	end

end