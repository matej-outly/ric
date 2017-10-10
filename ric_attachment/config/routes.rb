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
	if RicAttachment.editors.include?(:froala)
		resources :froala, controller: "froala", only: [:index, :create] do
			collection do 
				delete :destroy # Destroy action supports src param instead of standard ID
			end
		end
	end
	
	# TinyMCE interface
	resources :tinymce, controller: "tinymce", only: [:index, :create, :destroy] if RicAttachment.editors.include?(:tinymce)
	
end