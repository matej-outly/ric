# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sessions
# *
# * Author: Matěj Outlý
# * Date  : 18. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_rolling/application_controller"

module RicRolling
	class SessionsController < ApplicationController
		include RicRolling::Concerns::Controllers::SessionsController
	end
end
