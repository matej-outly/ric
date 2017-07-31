# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_plugin/concerns/controllers/plugins_controller"
		require "ric_plugin/concerns/controllers/subject_plugins_controller"
		
		isolate_namespace RicPlugin
	end
end
