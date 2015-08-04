# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Menu page relations
# *
# * Author: Matěj Outlý
# * Date  : 4. 8. 2015
# *
# *****************************************************************************

require_dependency "ric_website/admin_controller"

module RicWebsite
	class AdminMenuPageRelationsController < AdminController
		include RicWebsite::Concerns::Controllers::Admin::MenuPageRelationsController
	end
end