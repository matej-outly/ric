# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plugin relation
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	class PluginRelation < ActiveRecord::Base
		include RicPlugin::Concerns::Models::PluginRelation
	end
end
