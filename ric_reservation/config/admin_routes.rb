# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

RicReservation::AdminEngine.routes.draw do

	# Resources
	resources "resources", controller: "admin_resources" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

	# Events
	resources "events", only: [:show, :new, :edit, :create, :update, :destroy], controller: "admin_events"

	# Event modifiers
	post "event_modifiers/:id/:schedule_date", to: "admin_event_modifiers#create", as: "create_event_modifier"
	resources :event_modifiers, only: [:destroy], controller: "admin_event_modifiers"

	# Event reservations
	get "event_reservations/:id/:schedule_date", to: "admin_event_reservations#index", as: "event_reservations"
	get "event_reservations/:id/:schedule_date/new", to: "admin_event_reservations#new", as: "new_event_reservation"
	post "event_reservations/:id/:schedule_date", to: "admin_event_reservations#create", as: "create_event_reservation"
	put "event_reservations/:id/:schedule_date/anonymous", to: "admin_event_reservations#create_anonymous", as: "create_anonymous_event_reservation"
	resources :event_reservations, only: [:destroy], controller: "admin_event_reservations" do
		member do
			put "put_above_line"
			put "put_below_line"
		end
	end

	# Resource reservations
	resources :resource_reservations, except: [:index], controller: "admin_resource_reservations"

end
