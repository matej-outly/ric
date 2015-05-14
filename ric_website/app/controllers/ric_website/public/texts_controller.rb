# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Texts
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

require_dependency "ric_website/public_controller"

module RicWebsite
	class Public::TextsController < PublicController
		include RicWebsite::Concerns::Controllers::Public::TextsController
	end
end
