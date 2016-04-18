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

RicPaymentGopay::GatewayEngine.routes.draw do

	# Payments
	resources :payments, controller: "gateway_payments", only: [] do
		collection do
			get "notify"
		end
	end

end