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

require_dependency "ric_auth/application_controller"

module RicAuth
	class ProfilesController < ApplicationController
		include RicAuth::Concerns::Controllers::ProfilesController
	end
end