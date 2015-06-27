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

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductsController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductsController
	end
end
