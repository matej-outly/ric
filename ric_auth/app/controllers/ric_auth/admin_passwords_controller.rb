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

require_dependency "ric_auth/admin_controller"

module RicAuth
	class AdminPasswordsController < Devise::PasswordsController
		include RicAuth.devise_paths_concern
		
		if !RicAuth.admin_auth_layout.blank?
			layout RicAuth.admin_auth_layout.to_s
		end
	end
end