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

require_dependency "ric_settings/admin_controller"

module RicSettings
	class AdminSettingsController < AdminController
		include RicSettings::Concerns::Controllers::Admin::SettingsController
	end
end
