# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product photo
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductPhoto < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductPhoto
	end
end
