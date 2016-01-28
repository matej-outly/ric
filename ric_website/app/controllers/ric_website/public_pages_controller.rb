# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Pages
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

require_dependency "ric_website/public_controller"

module RicWebsite
	class PublicPagesController < PublicController
		include RicWebsite::Concerns::Controllers::Public::PagesController
	end
end
