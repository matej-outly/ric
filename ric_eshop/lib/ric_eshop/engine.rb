# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicEshop
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		#require 'ric_eshop/concerns/models/order'
		
		#
		# Controllers
		#
		#require 'ric_eshop/concerns/controllers/admin/orders_controller'

		isolate_namespace RicEshop
	end
end
