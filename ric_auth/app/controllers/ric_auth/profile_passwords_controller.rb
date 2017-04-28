# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Profile passwords
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/application_controller"

module RicAuth
	class ProfilePasswordsController < ApplicationController
		include RicAuth::Concerns::Controllers::ProfilePasswordsController
	end
end