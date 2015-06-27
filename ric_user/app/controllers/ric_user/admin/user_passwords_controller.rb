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

require_dependency "ric_user/admin_controller"

module RicUser
	class Admin
		class UserPasswordsController < AdminController
			include RicUser::Concerns::Controllers::Admin::UserPasswordsController
		end
	end
end