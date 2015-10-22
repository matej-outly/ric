# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_newsletter/concerns/controllers/public/customers_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicNewsletter

		#
		# Load public specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end

	end
end
