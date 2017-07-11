# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

module RicPartnership
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_partnership/concerns/controllers/partners_controller"
		
		isolate_namespace RicPartnership
	end
end
