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

RicPaymentFerbuy::GatewayEngine.routes.draw do

	# Payments
	resources :payments, controller: "gateway_payments", only: [] do
		collection do
			get "notify"
			post "notify"
		end
	end

end