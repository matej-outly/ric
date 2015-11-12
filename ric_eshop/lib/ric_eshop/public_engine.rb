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

module RicEshop
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_eshop/concerns/controllers/public/cart_controller'
		require 'ric_eshop/concerns/controllers/public/orders_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicEshop

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end
		
	end
end