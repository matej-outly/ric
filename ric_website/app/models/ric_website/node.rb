# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	class Node < ActiveRecord::Base
		include RicUrl::Concerns::Models::HierarchicalSlugGenerator if defined?(RicUrl)
		include RicWebsite::Concerns::Models::Node
	end
end
