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
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_reservation/concerns/controllers/admin/resources_controller'
		require 'ric_reservation/concerns/controllers/admin/events_controller'
		require 'ric_reservation/concerns/controllers/admin/event_modifiers_controller'
		require 'ric_reservation/concerns/controllers/admin/event_reservations_controller'
		require 'ric_reservation/concerns/controllers/admin/resource_reservations_controller'
		require 'ric_reservation/concerns/controllers/admin/timetables_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicReservation

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end
		
	end
end
