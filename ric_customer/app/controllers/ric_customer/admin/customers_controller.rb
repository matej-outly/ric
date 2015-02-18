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

require_dependency "ric_customer/application_controller"

module RicCustomer
	class Admin::CustomersController < ApplicationController
		include RicCustomer::Concerns::Controllers::Admin::CustomersController
	end
end
