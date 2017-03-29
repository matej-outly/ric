# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Price list
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	class PriceList < ActiveRecord::Base
		include RicPricing::Concerns::Models::PriceList
	end
end
