# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product manufacturer
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductManufacturer < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductManufacturer
	end
end
