# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_auth/concerns/controllers/admin/passwords_controller"
		require "ric_auth/concerns/controllers/admin/sessions_controller"
		require "ric_auth/concerns/controllers/admin/accounts_controller"
		
		#
		# Namespace
		#
		isolate_namespace RicAuth

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
