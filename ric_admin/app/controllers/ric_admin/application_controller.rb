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

		#
		# Title component
		#
		component RicAdmin::AdminTitleComponent

		#
		# Header logo component
		#
		component RicAdmin::AdminHeaderLogoComponent

		#
		# Header menu component
		#
		component RicAdmin::AdminHeaderMenuComponent
		
		#
		# Footer menu component
		#
		component RicAdmin::AdminFooterMenuComponent

		#
		# Footer copy component
		#
		component RicAdmin::AdminFooterCopyComponent

	end
end