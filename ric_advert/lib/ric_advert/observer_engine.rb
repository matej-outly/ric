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
	class ObserverEngine < ::Rails::Engine
		
		engine_name "ric_advert_observer"

		#
		# Controllers
		#
		require 'ric_advert/concerns/controllers/observer/advertisers_controller'
		require 'ric_advert/concerns/controllers/observer/banners_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicAdvert

		#
		# Load observer specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/observer_routes.rb")
		end

	end
end