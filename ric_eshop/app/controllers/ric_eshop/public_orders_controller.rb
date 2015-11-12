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

require_dependency "ric_eshop/public_controller"

module RicEshop
	class PublicOrdersController < PublicController
		include RicEshop::Concerns::Controllers::Public::OrdersController
	end
end