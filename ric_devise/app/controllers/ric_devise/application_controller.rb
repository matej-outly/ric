# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 26. 6. 2015
# *
# *****************************************************************************

module RicDevise
	class ApplicationController < ::ApplicationController

		#
		# Layout
		#
		layout "ric_admin"
		
		#
		# Title component
		#
		component RicAdmin::TitleComponent

		#
		# Header logo component
		#
		component RicAdmin::HeaderLogoComponent

		#
		# Footer copy component
		#
		component RicAdmin::FooterCopyComponent

	protected
		
	end
end
