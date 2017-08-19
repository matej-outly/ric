# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sessions
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	class SessionsController < Devise::SessionsController
		include RicAuth.devise_paths_concern
		include RicAuth::Concerns::Controllers::SessionsController

		if !RicAuth.layout.blank?
			layout RicAuth.layout.to_s
		end

		if RicAuth.authenticate_token == false
			skip_before_action :verify_authenticity_token
		end

	end
end