# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Privileges
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

require_dependency "ric_acl/application_controller"

module RicAcl
	class PrivilegesController < ApplicationController
		include RicAcl::Concerns::Controllers::PrivilegesController
	end
end