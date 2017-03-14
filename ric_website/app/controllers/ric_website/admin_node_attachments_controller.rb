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

require_dependency "ric_website/admin_controller"

module RicWebsite
	class AdminNodeAttachmentsController < AdminController
		include RicWebsite::Concerns::Controllers::Admin::NodeAttachmentsController
	end
end
