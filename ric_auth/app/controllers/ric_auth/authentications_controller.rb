# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authentications
# *
# * Author: Matěj Outlý
# * Date  : 28. 4. 2017
# *
# *****************************************************************************

module RicAuth
	class AuthenticationsController < ::ApplicationController # Cannot be under some authenticated controller
		include RicAuth.devise_paths_concern
		include RicAuth::Concerns::Controllers::AuthenticationsController
	end
end