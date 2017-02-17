# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Profile passowrds
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/admin_controller"

module RicAuth
	class AdminProfilePasswordsController < AdminController
		include RicAuth::Concerns::Controllers::Admin::ProfilePasswordsController
	end
end