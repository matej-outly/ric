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

module RicWebsite
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_website/concerns/controllers/admin/enums_controller"
		require "ric_website/concerns/controllers/admin/fields_controller"
		require "ric_website/concerns/controllers/admin/node_attachments_controller"
		require "ric_website/concerns/controllers/admin/nodes_controller"
		require "ric_website/concerns/controllers/admin/structures_controller"
		
		isolate_namespace RicWebsite

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end

	end
end
