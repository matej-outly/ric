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

require_dependency "ric_auth/admin_controller"

module RicAuth
	class AdminProfilesController < AdminController
		include RicAuth::Concerns::Controllers::Admin::ProfilesController
	end
end