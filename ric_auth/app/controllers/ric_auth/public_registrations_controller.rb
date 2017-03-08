# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Registrations
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	class PublicRegistrationsController < Devise::RegistrationsController
		include RicAuth.devise_paths_concern

		if !RicAuth.public_auth_layout.blank?
			layout RicAuth.public_auth_layout.to_s
		end
	end
end