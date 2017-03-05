# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

RicCalendar::Engine.routes.draw do

	resources :calendar, only: [:index] do
		collection do
			get "events"
		end
	end

	resources :calendar_events, only: [:new, :create, :show] do
		member do
			patch "update_schedule"
		end
	end

	resources :calendar_event_templates, only: [:new, :create, :update]

	# # Documents
	# resources :documents, only: [:show, :new, :create, :destroy]

	# # Document versions
	# resources :document_versions, only: [:destroy]

	# # Directory listing
	# resources :document_folders, only: [:index, :show, :new, :create, :destroy]

end
