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

require_dependency "ric_user/public_controller"

module RicUser
	class PublicUsersController < PublicController
		include RicUser::Concerns::Controllers::Public::UsersController
	end
end
