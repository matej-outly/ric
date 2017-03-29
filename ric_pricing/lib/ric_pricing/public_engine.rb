# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#

		isolate_namespace RicPricing

		#
		# Load public specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end
		
	end
end
