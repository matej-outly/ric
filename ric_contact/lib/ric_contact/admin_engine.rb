# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicContact
	class AdminEngine < ::Rails::Engine
		
		# Controllers
		require "ric_contact/concerns/controllers/admin/contact_messages_controller"
		require "ric_contact/concerns/controllers/admin/contact_people_controller"
		
		isolate_namespace RicContact

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
