# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicUrl
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_url/concerns/controllers/admin/slugs_controller"
		
		isolate_namespace RicUrl

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end

	end
end
