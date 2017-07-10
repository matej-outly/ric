# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

module RicSeason
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_season/concerns/controllers/seasons_controller"
		
		isolate_namespace RicSeason
	end
end
