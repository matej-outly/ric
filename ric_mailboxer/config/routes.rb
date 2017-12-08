# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

RicMailboxer::Engine.routes.draw do

	# Mailbox
	resource :mailbox, only: [:show] do
		member do
			get :trash
		end 

		# Conversations
		resources :conversations, only: [:show, :create, :update, :destroy] do
			member do 
				post :reply
				delete :trash
				put :untrash
			end
		end
	
	end

end
