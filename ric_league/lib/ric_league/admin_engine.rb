# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

module RicLeague
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_league/concerns/controllers/admin/teams_controller'
		require 'ric_league/concerns/controllers/admin/team_members_controller'
		require 'ric_league/concerns/controllers/admin/league_categories_controller'
		require 'ric_league/concerns/controllers/admin/league_seasons_controller'
		require 'ric_league/concerns/controllers/admin/league_season_team_relations_controller'
		require 'ric_league/concerns/controllers/admin/league_matches_controller'
		
		isolate_namespace RicLeague

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
