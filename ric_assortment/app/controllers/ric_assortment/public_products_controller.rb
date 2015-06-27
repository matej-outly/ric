# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Products
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/public_controller"

module RicAssortment
	class PublicProductsController < PublicController
		include RicAssortment::Concerns::Controllers::Public::ProductsController
	end
end
