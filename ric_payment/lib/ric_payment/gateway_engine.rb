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

module RicPayment
	class GatewayEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_payment/concerns/controllers/gateway/payments_controller'
		
		isolate_namespace RicPayment

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/gateway_routes.rb")
		end

	end
end
