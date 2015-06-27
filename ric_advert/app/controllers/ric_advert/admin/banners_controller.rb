# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Banners
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

require_dependency "ric_advert/admin_controller"

module RicAdvert
	class Admin
		class BannersController < AdminController
			include RicAdvert::Concerns::Controllers::Admin::BannersController
		end
	end
end