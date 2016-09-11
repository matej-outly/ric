# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 5. 5. 2015
# *
# *****************************************************************************

module RicAdmin
	class ApplicationController < ::ApplicationController

		#
		# Authenticate before every action
		#
		before_action :authenticate_user!

		#
		# Layout
		#
		layout "ric_admin"

	end
end