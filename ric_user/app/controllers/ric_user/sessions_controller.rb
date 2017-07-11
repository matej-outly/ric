# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Session
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_user/application_controller"

module RicUser
	class SessionsController < ApplicationController
		include RicUser::Concerns::Controllers::SessionsController
	end
end