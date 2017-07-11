# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Users
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_user/application_controller"

module RicUser
	class UsersController < ApplicationController
		include RicUser::Concerns::Controllers::UsersController
	end
end

