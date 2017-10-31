# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Stages
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

require_dependency "ric_staging/application_controller"

module RicStaging
	class StagesController < ApplicationController
		include RicStaging::Concerns::Controllers::StagesController
	end
end
