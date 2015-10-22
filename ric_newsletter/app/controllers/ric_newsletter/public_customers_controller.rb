# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customers
# *
# * Author: Matěj Outlý
# * Date  : 22. 10. 2015
# *
# *****************************************************************************

require_dependency "ric_newsletter/public_controller"

module RicNewsletter
	class PublicCustomersController < PublicController
		include RicNewsletter::Concerns::Controllers::Public::CustomersController
	end
end