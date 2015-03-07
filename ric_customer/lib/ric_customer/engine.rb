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

module RicCustomer
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		require 'ric_customer/concerns/models/customer'
		
		#
		# Controllers
		#
		require 'ric_customer/concerns/controllers/admin/customers_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicCustomer
	end
end
