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

require_dependency "ric_user/public_controller"

module RicUser
	class PublicPeopleSelectorsController < PublicController
		include RicUser::Concerns::Controllers::Public::PeopleSelectorsController
	end
end