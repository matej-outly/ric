# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node attachment
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	class NodeAttachment < ActiveRecord::Base
		include RicWebsite::Concerns::Models::NodeAttachment
	end
end
