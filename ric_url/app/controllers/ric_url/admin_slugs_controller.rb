# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slugs
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2016
# *
# *****************************************************************************

require_dependency "ric_url/admin_controller"

module RicUrl
	class AdminSlugsController < AdminController
		include RicUrl::Concerns::Controllers::Admin::SlugsController
	end
end
