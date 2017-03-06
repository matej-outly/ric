# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Confirmations
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

require_dependency "ric_auth/public_controller"

module RicAuth
	class PublicConfirmationsController < Devise::ConfirmationsController
		include RicAuth.devise_paths_concern

		if !RicAuth.public_auth_layout.blank?
			layout RicAuth.public_auth_layout.to_s
		end
	end
end