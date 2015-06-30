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

require_dependency "ric_contact/public_controller"

module RicContact
	class PublicContactMessagesController < PublicController
		include RicContact::Concerns::Controllers::Public::ContactMessagesController
	end
end
