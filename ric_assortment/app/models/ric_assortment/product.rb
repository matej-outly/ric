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
		include RicUrl::Concerns::Models::SlugGenerator if defined?(RicUrl)
		include RicAssortment::Concerns::Models::Product
	end
end
