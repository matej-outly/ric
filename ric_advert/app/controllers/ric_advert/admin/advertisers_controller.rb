# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Advertisers
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

require_dependency "ric_advert/admin_controller"

module RicAdvert
	class Admin
		class AdvertisersController < AdminController
			include RicAdvert::Concerns::Controllers::Admin::AdvertisersController
		end
	end
end
