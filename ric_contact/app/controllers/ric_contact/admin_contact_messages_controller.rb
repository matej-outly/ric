# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact messages
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_contact/admin_controller"

module RicContact
	class AdminContactMessagesController < AdminController
		include RicContact::Concerns::Controllers::Admin::ContactMessagesController
	end
end

