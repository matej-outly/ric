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

RicAssortment::AdminEngine.routes.draw do

	# Products
	resources :products, controller: "admin_products"

	# Product attachments
	resources :product_attachments, controller: "admin_product_attachments"

	# Product attachment bindings
	resources :product_attachment_bindings, only: [:edit, :update, :destroy], controller: "admin_product_attachment_bindings"

	# Product categories
	resources :product_categories, controller: "admin_product_categories"

	# Product category bindings
	resources :product_category_bindings, only: [:edit, :update, :destroy], controller: "admin_product_category_bindings"

	# Product photos
	resources :product_photos, only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_product_photos"

end