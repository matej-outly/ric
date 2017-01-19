# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node picture
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	class NodePicture < ActiveRecord::Base
		include RicWebsite::Concerns::Models::NodePicture
	end
end
