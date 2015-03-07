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

RicCustomer::Engine.routes.draw do

	#
	# Admin
	#
	namespace :admin do
		
		# Customers
		resources :customers do
			collection do
				post "index_search"
				get "statistic/:statistic", action: "statistic", as: "statistic"
				post "statistic_search/:statistic", action: "statistic_search", as: "statistic_search"
			end
		end

	end

end
