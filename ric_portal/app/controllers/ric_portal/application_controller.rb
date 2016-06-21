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

module RicPortal
	class ApplicationController < ::ApplicationController

		#
		# Layout
		#
		layout "ric_portal"

		#
		# Title component
		#
		component RicPortal::PortalTitleComponent

		#
		# Header logo component
		#
		component RicPortal::PortalHeaderLogoComponent

		#
		# Header menu component
		#
		component RicAdmin::HeaderMenuComponent
		
		#
		# Footer component
		#
		component RicPortal::PortalFooterComponent

	end
end