# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Attachments
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

require_dependency "ric_attachment/application_controller"

module RicAttachment
	class EditableAttachmentsController < ApplicationController
		include RicAttachment::Concerns::Controllers::EditableAttachmentsController
	end
end
