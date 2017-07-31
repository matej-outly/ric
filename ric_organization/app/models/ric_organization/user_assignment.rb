# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User assignment
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	class UserAssignment < ActiveRecord::Base
		include RicOrganization::Concerns::Models::UserAssignment
	end
end