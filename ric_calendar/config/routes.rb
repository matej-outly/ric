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

	# Calendars
	resources :calendars, except: [:show] do
		collection do 
			get "events"
			get "resources"
		end
	end

	# Events
	resources :events, except: [:index] do
		member do
			patch "update_schedule"
		end
	end

end
