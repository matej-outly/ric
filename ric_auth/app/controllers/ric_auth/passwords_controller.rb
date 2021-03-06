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

module RicAuth
	class PasswordsController < Devise::PasswordsController
		include RicAuth.devise_paths_concern

		if !RicAuth.layout.blank?
			layout RicAuth.layout.to_s
		end
	end
end