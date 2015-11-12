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
	resources :orders, controller: "public_orders", only: [:new, :create]

	# Cart
	get "cart/get", to: "public_cart#get"
	get "cart/add/:id", to: "public_cart#add", as: "cart_add"
	get "cart/remove/:id", to: "public_cart#remove", as: "cart_remove"
	get "cart/clear", to: "public_cart#clear"

end
