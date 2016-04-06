# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact people
# *
# * Author: Matěj Outlý
# * Date  : 6. 4. 2016
# *
# *****************************************************************************

require_dependency "ric_contact/admin_controller"

module RicContact
	class AdminContactPeopleController < AdminController
		include RicContact::Concerns::Controllers::Admin::ContactPeopleController
	end
end