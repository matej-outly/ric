# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product variant
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductVariant < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductVariant
	end
end
