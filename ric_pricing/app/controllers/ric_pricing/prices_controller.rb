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

require_dependency "ric_pricing/application_controller"

module RicPricing
	class PricesController < ApplicationController
		include RicPricing::Concerns::Controllers::PricesController
	end
end
