# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Registrations
# *
# * Author: Matěj Outlý
# * Date  : 18. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_rolling/application_controller"

module RicRolling
	class RegistrationsController < ApplicationController
		include RicRolling::Concerns::Controllers::RegistrationsController
	end
end
