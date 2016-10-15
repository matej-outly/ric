# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product teaser
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	class ProductTeaser < ActiveRecord::Base
		include RicAssortment::Concerns::Models::ProductTeaser
	end
end
