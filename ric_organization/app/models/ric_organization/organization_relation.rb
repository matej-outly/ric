# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization relation
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	class OrganizationRelation < ActiveRecord::Base
		include RicOrganization::Concerns::Models::OrganizationRelation
	end
end