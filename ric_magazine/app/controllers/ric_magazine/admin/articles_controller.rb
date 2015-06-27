# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Articles
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

require_dependency "ric_magazine/admin_controller"

module RicMagazine
	class Admin
		class ArticlesController < AdminController
			include RicMagazine::Concerns::Controllers::Admin::ArticlesController
		end
	end
end

