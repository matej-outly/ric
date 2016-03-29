# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * References
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_partnership/admin_controller"

module RicPartnership
	class AdminReferencesController < AdminController
		include RicPartnership::Concerns::Controllers::Admin::ReferencesController
	end
end

