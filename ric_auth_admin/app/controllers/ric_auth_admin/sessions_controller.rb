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

module RicAuthAdmin
	class SessionsController < Devise::SessionsController
		include RicAuth.devise_paths_concern
		include RicAuthAdmin::Concerns::Controllers::SessionsController
		
		if !RicAuthAdmin.layout.blank?
			layout RicAuthAdmin.layout.to_s
		end
	end
end