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

module RicReservation
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_reservation/concerns/controllers/public/timetables_controller'
		require 'ric_reservation/concerns/controllers/public/resource_reservations_controller'

		#
		# Namespace
		#
		isolate_namespace RicReservation

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end
		
	end
end