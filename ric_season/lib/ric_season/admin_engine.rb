# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

module RicSeason
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_season/concerns/controllers/admin/seasons_controller'
		
		isolate_namespace RicSeason

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
