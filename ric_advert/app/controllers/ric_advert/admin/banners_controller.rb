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

require_dependency "ric_advert/application_controller"

module RicAdvert
	class Admin::BannersController < ApplicationController
		include RicAdvert::Concerns::Controllers::Admin::BannersController
	end
end