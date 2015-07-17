# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Pages
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

require_dependency "ric_website/admin_controller"

module RicWebsite
	class AdminPagesController < AdminController
		include RicWebsite::Concerns::Controllers::Admin::PagesController
	end
end
