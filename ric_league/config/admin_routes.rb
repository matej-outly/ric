# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

RicLeague::AdminEngine.routes.draw do

	# Teams
	resources :teams, controller: "admin_teams" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

	# Team members
	resources :team_members, controller: "admin_team_members", except: [:index] do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

	# League seasons
	resources :league_seasons, controller: "admin_league_seasons"

	# League season team relations
	resources :league_season_team_relations, only: [:edit, :update, :destroy], controller: "admin_league_season_team_relations"

	# League matches
	resources :league_matches, controller: "admin_league_matches"

	# League categories
	resources :league_categories, controller: "admin_league_categories" do
		member do
			put "move/:relation/:destination_id", action: "move", as: "move"
		end
	end

end
