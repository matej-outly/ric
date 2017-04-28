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
	end
end