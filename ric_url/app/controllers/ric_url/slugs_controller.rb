# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slugs
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2016
# *
# *****************************************************************************

require_dependency "ric_url/application_controller"

module RicUrl
	class SlugsController < ApplicationController
		include RicUrl::Concerns::Controllers::SlugsController
	end
end
