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
	resources :products, controller: "admin_products" do
		member do
			post "duplicate"
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
		collection do
			get "from_category/:product_category_id", to: "admin_products#from_category", as: "from_category"
			get "search"
		end
	end

	# Product attachments
	resources :product_attachments, controller: "admin_product_attachments"

	# Product attachment relations
	resources :product_attachment_relations, only: [:edit, :update, :destroy], controller: "admin_product_attachment_relations"

	# Product categories
	resources :product_categories, controller: "admin_product_categories" do
		collection do 
			get "search"
		end
	end

	# Product category relations
	resources :product_category_relations, only: [:edit, :update, :destroy], controller: "admin_product_category_relations"

	# Product photos
	resources :product_photos, only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_product_photos"

	# Product variants
	resources :product_variants, only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_product_variants"

	# Product tickers
	resources :product_tickers, controller: "admin_product_tickers" do
		member do 
			delete "unbind_product"
		end
		collection do 
			get "search"
		end
	end

end