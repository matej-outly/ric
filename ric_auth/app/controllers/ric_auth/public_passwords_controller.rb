# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Passwords
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/public_controller"

module RicAuth
	class PublicPasswordsController < Devise::SessionsController
	end
end