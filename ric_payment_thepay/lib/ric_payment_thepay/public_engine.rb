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

module RicPaymentThepay
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_payment_thepay/concerns/controllers/public/payments_controller'
		
		isolate_namespace RicPaymentThepay

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end

	end
end
