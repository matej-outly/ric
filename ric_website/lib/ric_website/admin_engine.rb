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
		require 'ric_website/concerns/controllers/admin/texts_controller'
		require 'ric_website/concerns/controllers/admin/text_attachments_controller'
		require 'ric_website/concerns/controllers/admin/pages_controller'
		require 'ric_website/concerns/controllers/admin/page_blocks_controller'
		require 'ric_website/concerns/controllers/admin/page_dynamic_controller'
		require 'ric_website/concerns/controllers/admin/page_menu_relations_controller'
		require 'ric_website/concerns/controllers/admin/menus_controller'
		require 'ric_website/concerns/controllers/admin/menu_page_relations_controller'
		require 'ric_website/concerns/controllers/admin/settings_controller'
		
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
