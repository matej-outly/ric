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

module RicAssortment
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_assortment/concerns/controllers/public/products_controller'
		
		isolate_namespace RicAssortment
	end
end