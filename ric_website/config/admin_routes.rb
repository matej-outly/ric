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
	resources :pages, controller: "admin_pages"
	resources :page_dynamic, only: [], controller: "admin_page_dynamic" do
		collection do
			get "available_models"
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

end