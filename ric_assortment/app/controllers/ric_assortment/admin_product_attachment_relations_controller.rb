# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product attachment relation
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_assortment/admin_controller"

module RicAssortment
	class AdminProductAttachmentRelationsController < AdminController
		include RicAssortment::Concerns::Controllers::Admin::ProductAttachmentRelationsController
	end
end