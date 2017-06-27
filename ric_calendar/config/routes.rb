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
			get  "export"
			get  "events"
			post "events"
			get  "resources"
			post "resources"
		end

		# iCalendar output
		resources :icals, only: [:show]
	end

	# Events
	resources :events, except: [:index]
end
