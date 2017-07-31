# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Subject plugins
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

require_dependency "ric_plugin/application_controller"

module RicPlugin
	class SubjectPluginsController < ApplicationController
		include RicPlugin::Concerns::Controllers::SubjectPluginsController
	end
end