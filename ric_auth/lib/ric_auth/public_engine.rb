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
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_auth/concerns/controllers/public/passwords_controller"
		require "ric_auth/concerns/controllers/public/registrations_controller"
		require "ric_auth/concerns/controllers/public/sessions_controller"
		require "ric_auth/concerns/controllers/public/accounts_controller"
		
		#
		# Namespace
		#
		isolate_namespace RicAuth

		#
		# Load public specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end
		
	end
end
