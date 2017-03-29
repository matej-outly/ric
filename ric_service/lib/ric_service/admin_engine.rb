# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicService
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_service/concerns/controllers/admin/services_controller"
		
		isolate_namespace RicService

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
