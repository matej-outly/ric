# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

RicEshop::PublicEngine.routes.draw do

	# Orders
	resources :orders, controller: "public_orders", only: [:new, :create] do
		member do
			get "finalize"
		end
		collection do
			post "preserve"
		end
	end

	# Cart
	get "cart/get", to: "public_cart#get"
	get "cart/add", to: "public_cart#add"
	post "cart/add", to: "public_cart#add"
	get "cart/remove", to: "public_cart#remove"
	get "cart/clear", to: "public_cart#clear"

end
