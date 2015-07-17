# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page menu relations
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

require_dependency "ric_website/admin_controller"

module RicWebsite
	class AdminPageMenuRelationsController < AdminController
		include RicWebsite::Concerns::Controllers::Admin::PageMenuRelationsController
	end
end
