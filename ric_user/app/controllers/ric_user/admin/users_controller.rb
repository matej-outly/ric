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

require_dependency "ric_user/admin_controller"

module RicUser
	class Admin
		class UsersController < AdminController
			include RicUser::Concerns::Controllers::Admin::UsersController
		end
	end
end

