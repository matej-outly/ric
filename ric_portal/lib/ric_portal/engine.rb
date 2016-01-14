# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 27. 4. 2015
# *
# *****************************************************************************

module RicPortal
	class Engine < ::Rails::Engine

		#
		# Controllers
		#
		require 'ric_portal/concerns/controllers/dashboard_controller'

		#
		# Namespace
		#
		isolate_namespace RicPortal
		
	end
end
