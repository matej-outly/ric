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
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_user/concerns/controllers/admin/users_controller"
		require "ric_user/concerns/controllers/admin/user_passwords_controller"
		require "ric_user/concerns/controllers/admin/people_selectors_controller"
		
		isolate_namespace RicUser

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
