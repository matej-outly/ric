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

module RicNotification
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_notification/concerns/controllers/admin/notifications_controller"
		require "ric_notification/concerns/controllers/admin/notification_templates_controller"
		
		isolate_namespace RicNotification

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
