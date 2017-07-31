# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plugin
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	class Plugin < ActiveRecord::Base
		include RicPlugin::Concerns::Models::Plugin
	end
end
