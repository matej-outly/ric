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

require_dependency "ric_user/application_controller"

module RicUser
	class AdminPeopleSelectorsController < ApplicationController
		include RicUser::Concerns::Controllers::PeopleSelectorsController
	end
end