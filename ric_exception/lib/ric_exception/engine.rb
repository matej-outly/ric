# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

module RicException
	class Engine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_exception/concerns/controllers/exceptions_controller"
		
		#
		# Namespace
		#
		isolate_namespace RicException

	end
end
