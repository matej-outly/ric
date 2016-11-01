# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product manufacturers
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductManufacturersController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductManufacturersController
	end
end