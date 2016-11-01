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
			post "filter"
			get "search"
		end

		# Product pictures
		if RicAssortment.enable_pictures
			resources :product_pictures, only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_product_pictures" do
				member do
					put "move/:relation/:destination_id", action: "move", as: "move"
				end
			end
		end

	end
	
	# Product categories
	resources :product_categories, controller: "admin_product_categories" do
		member do
			put "move_up"
			put "move_down"
		end
		collection do 
			get "search"
		end
	end
	
	# Products product attachments
	if RicAssortment.enable_attachments
		resources :products_product_attachments, only: [:edit, :update, :destroy], controller: "admin_products_product_attachments"
	end

	# Product attachments
	if RicAssortment.enable_attachments
		resources :product_attachments, controller: "admin_product_attachments" do
			collection do 
				get "search"
			end
		end
	end

	# Product teasers
	if RicAssortment.enable_teasers
		resources :product_teasers, controller: "admin_product_teasers" do
			collection do 
				get "search"
			end
		end
	end

	# Product manufacturers
	if RicAssortment.enable_manufacturers
		resources :product_manufacturers, controller: "admin_product_manufacturers" do
			collection do 
				get "search"
			end
		end
	end

end