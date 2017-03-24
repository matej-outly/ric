# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Overrides
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/public_controller"

module RicAuth
	class PublicOverridesController < PublicController
		include RicAuth::Concerns::Controllers::Public::OverridesController
	end
end