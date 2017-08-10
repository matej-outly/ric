# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Roles
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_user/application_controller"

module RicUser
	class RolesController < ApplicationController
		include RicUser::Concerns::Controllers::RolesController
	end
end

