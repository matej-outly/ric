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

module RicAdmin
	class Engine < ::Rails::Engine

		#
		# Controllers
		#
		require 'ric_admin/concerns/controllers/dashboard_controller'

		#
		# Namespace
		#
		isolate_namespace RicAdmin
		
	end
end
