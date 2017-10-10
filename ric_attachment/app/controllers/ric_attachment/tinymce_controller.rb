# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * TinyMCE
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

require_dependency "ric_attachment/application_controller"

module RicAttachment
	class TinymceController < ApplicationController
		include RicAttachment::Concerns::Controllers::TinymceController
	end
end
