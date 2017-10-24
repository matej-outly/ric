# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicPerson
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_person/concerns/controllers/people_selectors_controller"
		
		isolate_namespace RicPerson
	end
end
