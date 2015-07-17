# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Text attachments
# *
# * Author: Matěj Outlý
# * Date  : 17. 7. 2015
# *
# *****************************************************************************

require_dependency "ric_website/admin_controller"

module RicWebsite
	class AdminTextAttachmentsController < AdminController
		include RicWebsite::Concerns::Controllers::Admin::TextAttachmentsController
	end
end
