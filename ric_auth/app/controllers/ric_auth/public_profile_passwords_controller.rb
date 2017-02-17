# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Profile passwords
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/public_controller"

module RicAuth
	class PublicProfilePasswordsController < PublicController
		include RicAuth::Concerns::Controllers::Public::ProfilePasswordsController
	end
end