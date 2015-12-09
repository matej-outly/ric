# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

RicCustomer::AdminEngine.routes.draw do

	# Customers
	resources :customers, controller: "admin_customers" do
		collection do
			post "index_filter"
			get "statistic/:statistic", action: "statistic", as: "statistic"
			post "statistic_filter/:statistic", action: "statistic_filter", as: "statistic_filter"
		end
	end

end
