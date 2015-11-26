# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product panel / sub product relation
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductPanelSubProductRelationsController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductPanelSubProductRelationsController
	end
end