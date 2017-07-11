# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User passwords
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_user/application_controller"

module RicUser
	class AdminUserPasswordsController < ApplicationController
		include RicUser::Concerns::Controllers::UserPasswordsController
	end
end