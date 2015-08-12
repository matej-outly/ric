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

module RicAssortment
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_assortment/concerns/controllers/public/products_controller'
		
		isolate_namespace RicAssortment

		#
		# Load public specific routes
		#
		initializer :set_ric_assortment_public_routes, after: :set_routes_reloader_hook do
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			require config_path + "/public_routes.rb"
		end

	end
end