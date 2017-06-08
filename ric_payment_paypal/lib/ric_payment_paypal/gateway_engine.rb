# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentPaypal
	class GatewayEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_payment_paypal/concerns/controllers/gateway/payments_controller"
		
		isolate_namespace RicPaymentPaypal

		#
		# Load gateway specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/gateway_routes.rb")
		end

	end
end
