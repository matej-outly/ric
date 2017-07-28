# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_pricing/concerns/controllers/price_lists_controller"
		require "ric_pricing/concerns/controllers/prices_controller"
		
		isolate_namespace RicPricing
		
	end
end
