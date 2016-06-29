# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class GatewayEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_payment_ferbuy/concerns/controllers/gateway/payments_controller'
		
		isolate_namespace RicPaymentFerbuy

		#
		# Load gateway specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/gateway_routes.rb")
		end

	end
end