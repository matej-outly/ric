# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

RicAssortment::PublicEngine.routes.draw do

	# Products
	resources :products, only: [:index, :show], controller: "public_products" do
		collection do
			get "from_category/:product_category_id", to: "public_products#from_category", as: "from_category"
		end
	end

end