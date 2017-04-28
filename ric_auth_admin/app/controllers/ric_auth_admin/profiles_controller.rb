# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Profiles
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth_admin/application_controller"

module RicAuthAdmin
	class ProfilesController < ApplicationController
		include RicAuthAdmin::Concerns::Controllers::ProfilesController
	end
end