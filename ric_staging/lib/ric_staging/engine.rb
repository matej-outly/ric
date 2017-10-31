# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 31. 5. 2015
# *
# *****************************************************************************

module RicStaging
	class Engine < ::Rails::Engine

		# Controllers
		require "ric_staging/concerns/controllers/stages_controller"
		
		isolate_namespace RicStaging
	end
end
