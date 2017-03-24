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
		require "ric_auth/concerns/controllers/public/overrides_controller"
		require "ric_auth/concerns/controllers/public/profile_passwords_controller"
		require "ric_auth/concerns/controllers/public/profiles_controller"
		
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
