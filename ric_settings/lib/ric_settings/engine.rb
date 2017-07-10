# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicSettings
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_settings/concerns/controllers/settings_controller"
		
		isolate_namespace RicSettings
	end
end
