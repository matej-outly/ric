# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization assignment
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	class OrganizationAssignment < ActiveRecord::Base
		include RicOrganization::Concerns::Models::OrganizationAssignment
	end
end