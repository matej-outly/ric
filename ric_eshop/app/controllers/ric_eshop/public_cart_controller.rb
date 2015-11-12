# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Cart
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_eshop/public_controller"

module RicEshop
	class PublicCartController < PublicController
		include RicEshop::Concerns::Controllers::Public::CartController
	end
end