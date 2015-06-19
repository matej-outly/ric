# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product
# *
# * Author: Matěj Outlý
# * Date  : 19. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	class Product < ActiveRecord::Base
		include RicAssortment::Concerns::Models::Product
	end
end
