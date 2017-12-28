# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Stages
# *
# * Author: Matěj Outlý
# * Date  : 28. 12. 2017
# *
# *****************************************************************************

require_dependency "ric_tagging/application_controller"

module RicTagging
	class TagsController < ApplicationController
		include RicTagging::Concerns::Controllers::TagsController
	end
end
