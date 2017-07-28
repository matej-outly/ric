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

require_dependency "ric_pricing/application_controller"

module RicPricing
	class PriceListsController < ApplicationController
		include RicPricing::Concerns::Controllers::PriceListsController
	end
end

