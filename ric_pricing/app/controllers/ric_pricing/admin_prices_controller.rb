# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Prices
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

require_dependency "ric_pricing/admin_controller"

module RicPricing
	class AdminPricesController < AdminController
		include RicPricing::Concerns::Controllers::Admin::PricesController
	end
end
