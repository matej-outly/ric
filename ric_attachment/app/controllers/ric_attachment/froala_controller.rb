# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Froala
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

require_dependency "ric_attachment/application_controller"

module RicAttachment
	class FroalaController < ApplicationController
		include RicAttachment::Concerns::Controllers::FroalaController
	end
end
