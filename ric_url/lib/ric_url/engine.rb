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

module RicUrl
	class Engine < ::Rails::Engine

		# Controllers
		require "ric_url/concerns/controllers/slugs_controller"
		
		isolate_namespace RicUrl
	end
end
