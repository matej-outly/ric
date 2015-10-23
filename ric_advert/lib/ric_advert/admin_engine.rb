# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	class AdminEngine < ::Rails::Engine
		
		engine_name "ric_advert_admin"

		#
		# Controllers
		#
		require 'ric_advert/concerns/controllers/admin/advertisers_controller'
		require 'ric_advert/concerns/controllers/admin/banners_controller'

		#
		# Namespace
		#
		isolate_namespace RicAdvert

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
