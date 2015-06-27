# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Articles
# *
# * Author: Matěj Outlý
# * Date  : 13. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_magazine/public_controller"

module RicMagazine
	class PublicArticlesController < PublicController
		include RicMagazine::Concerns::Controllers::Public::ArticlesController
	end
end
