# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_organization/concerns/controllers/organizations_controller"
		
		isolate_namespace RicOrganization
		
	end
end
