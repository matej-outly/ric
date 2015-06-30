# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Branches
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_contact/admin_controller"

module RicContact
	class AdminBranchesController < AdminController
		include RicContact::Concerns::Controllers::Admin::BranchesController
	end
end

