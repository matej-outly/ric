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

	# Pages
	resources :pages, controller: "admin_pages" do
		member do
			put "move_up"
			put "move_down"
		end
	end

	# Page natures
	resources :page_natures, only: [:show], controller: "admin_page_natures"

	# Page blocks
	resources :page_blocks, except: [:index], controller: "admin_page_blocks" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

	# Page menu relations
	resources :page_menu_relations, only: [:edit, :update, :destroy], controller: "admin_page_menu_relations"

	# Menus
	resources :menus, controller: "admin_menus"

	# Menu page relations
	resources :menu_page_relations, only: [:edit, :update, :destroy], controller: "admin_menu_page_relations"

	# Texts
	resources :texts, controller: "admin_texts"

	# Text attachments
	resources :text_attachments, only: [:create, :destroy], controller: "admin_text_attachments" do
		collection do
			get "links"
			get "images"
		end
	end

	# Settings
	get "settings", to: "admin_settings#show"
	get "settings/edit", to: "admin_settings#edit"
	patch "settings", to: "admin_settings#update"
	put "settings", to: "admin_settings#update"

end
