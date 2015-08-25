# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicJournal
	class PublicEngine < ::Rails::Engine

		#
		# Controllers
		#
		require 'ric_journal/concerns/controllers/public/newies_controller'
		require 'ric_journal/concerns/controllers/public/events_controller'

		isolate_namespace RicJournal

		#
		# Load public specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/public_routes.rb")
		end

	end
end
