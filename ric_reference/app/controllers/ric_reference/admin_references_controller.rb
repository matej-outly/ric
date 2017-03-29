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

require_dependency "ric_reference/admin_controller"

module RicReference
	class AdminReferencesController < AdminController
		include RicReference::Concerns::Controllers::Admin::ReferencesController
	end
end

