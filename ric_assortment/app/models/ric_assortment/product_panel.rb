# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product panel
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductPanel < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductPanel
	end
end
