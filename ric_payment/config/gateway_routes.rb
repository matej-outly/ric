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

RicPayment::GatewayEngine.routes.draw do

	# Payments
	resources :payments, controller: "gateway_payments", only: [] do 
		member do
			get "notify"
		end
	end

end