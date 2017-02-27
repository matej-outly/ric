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

RicWebsite::AdminEngine.routes.draw do

	# Structures
	resources :structures, controller: "admin_structures" do

		# Fields
		resources :fields, controller: "admin_fields", except: [:index] do
			member do
				put "move/:relation/:destination_id", action: "move", as: "move"
			end
		end

	end

	# Enums
	resources :enums, controller: "admin_enums" do
		collection do
			get "search"
		end
	end

	# Nodes
	resources :nodes, controller: "admin_nodes" do
		collection do
			get "tree"
			get "lazy_tree"
			get "search"
		end
		member do
			put "generate_slugs"
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

end
