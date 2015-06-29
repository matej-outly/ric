# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product photos
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductPhotosController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductPhotosController
	end
end
