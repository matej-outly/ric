# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_user/concerns/controllers/public/users_controller"
		require "ric_user/concerns/controllers/public/session_controller"
		require "ric_user/concerns/controllers/public/people_selectors_controller"
		
		isolate_namespace RicUser

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end

	end
end
