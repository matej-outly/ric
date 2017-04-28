# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Overrides
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/application_controller"

module RicAuth
	class OverridesController < ApplicationController
		include RicAuth::Concerns::Controllers::OverridesController
	end
end