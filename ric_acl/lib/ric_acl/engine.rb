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

module RicAcl
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_acl/concerns/controllers/privileges_controller"
		
		isolate_namespace RicAcl

	end
end
