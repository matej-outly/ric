# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organizations
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

require_dependency "ric_organization/application_controller"

module RicOrganization
	class OrganizationsController < ApplicationController
		include RicOrganization::Concerns::Controllers::OrganizationsController
	end
end
