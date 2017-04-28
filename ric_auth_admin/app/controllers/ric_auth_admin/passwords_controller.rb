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

module RicAuthAdmin
	class PasswordsController < Devise::PasswordsController
		include RicAuth.devise_paths_concern
		
		if !RicAuthAdmin.layout.blank?
			layout RicAuthAdmin.layout.to_s
		end
	end
end