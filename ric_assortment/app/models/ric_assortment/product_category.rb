# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product category
# *
# * Author: Matěj Outlý
# * Date  : 19. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductCategory < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductCategory
	end
end
