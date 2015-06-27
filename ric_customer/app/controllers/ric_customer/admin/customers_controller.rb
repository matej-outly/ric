# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customers
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

require_dependency "ric_customer/admin_controller"

module RicCustomer
	class Admin
		class CustomersController < AdminController
			include RicCustomer::Concerns::Controllers::Admin::CustomersController
		end
	end
end
