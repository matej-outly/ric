# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product ticker
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductTicker < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductTicker
	end
end
