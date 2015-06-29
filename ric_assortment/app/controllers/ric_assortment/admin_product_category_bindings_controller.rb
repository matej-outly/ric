# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product category binding
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductCategoryBindingsController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductCategoryBindingsController
	end
end
