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

module RicTagging
	class Engine < ::Rails::Engine

		# Controllers
		require "ric_tagging/concerns/controllers/tags_controller"
		
		isolate_namespace RicTagging
	end
end
