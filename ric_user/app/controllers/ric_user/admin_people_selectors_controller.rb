# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * People selectors
# *
# * Author: Matěj Outlý
# * Date  : 11. 4. 2017
# *
# *****************************************************************************

require_dependency "ric_user/admin_controller"

module RicUser
	class AdminPeopleSelectorsController < AdminController
		include RicUser::Concerns::Controllers::Admin::PeopleSelectorsController
	end
end