# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Price lists
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

require_dependency "ric_pricing/admin_controller"

module RicPricing
	class AdminPriceListsController < AdminController
		include RicPricing::Concerns::Controllers::Admin::PriceListsController
	end
end

