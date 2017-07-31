# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plugins
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

require_dependency "ric_plugin/application_controller"

module RicPlugin
	class PluginsController < ApplicationController
		include RicPlugin::Concerns::Controllers::PluginsController
	end
end