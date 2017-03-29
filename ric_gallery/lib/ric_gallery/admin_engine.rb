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

module RicGallery
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_gallery/concerns/controllers/admin/gallery_directories_controller"
		require "ric_gallery/concerns/controllers/admin/gallery_pictures_controller"

		isolate_namespace RicGallery

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
