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
