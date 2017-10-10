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

RicAttachment::Engine.routes.draw do
	
	# Read attachment interface
	resources :attachments, only: [:show]

	# Froala interface
	resources :froala, controller: "froala", only: [:index, :create, :update, :destroy]
	
	# TinyMCE interface
	resources :tinymce, controller: "tinymce", only: [:index, :create, :update, :destroy]
	
end