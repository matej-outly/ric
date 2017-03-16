# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node attachments
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

require_dependency "ric_website/public_controller"

module RicWebsite
	class PublicNodeAttachmentsController < PublicController
		include RicWebsite::Concerns::Controllers::Public::NodeAttachmentsController
	end
end
