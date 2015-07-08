# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product attachment binding
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductAttachmentBindingsController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductAttachmentBindingsController
	end
end