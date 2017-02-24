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
	class PublicSessionsController < Devise::SessionsController
		include RicAuth.devise_paths_concern
	end
end