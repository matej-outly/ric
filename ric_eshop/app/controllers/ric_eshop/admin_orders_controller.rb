# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Orders
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_eshop/admin_controller"

module RicEshop
	class AdminOrdersController < AdminController
		include RicEshop::Concerns::Controllers::Admin::OrdersController
	end
end