# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Settings
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

require_dependency "ric_website/admin_controller"

module RicWebsite
	class AdminSettingsController < AdminController
		include RicWebsite::Concerns::Controllers::Admin::SettingsController
	end
end
