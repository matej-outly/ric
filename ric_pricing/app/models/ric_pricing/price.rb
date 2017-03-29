# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Price
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	class Price < ActiveRecord::Base
		include RicPricing::Concerns::Models::Price
	end
end