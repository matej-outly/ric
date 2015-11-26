# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Session
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_user/public_controller"

module RicUser
	class PublicSessionController < PublicController
		include RicUser::Concerns::Controllers::Public::SessionController
	end
end