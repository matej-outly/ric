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

require_dependency "ric_settings/application_controller"

module RicSettings
	class SettingsController < ApplicationController
		include RicSettings::Concerns::Controllers::SettingsController
	end
end
