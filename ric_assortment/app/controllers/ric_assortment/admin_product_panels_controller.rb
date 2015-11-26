# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product panels
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductPanelsController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductPanelsController
	end
end
