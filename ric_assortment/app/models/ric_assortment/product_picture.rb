# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product picture
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductPicture < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductPicture
	end
end
