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

require_dependency "ric_advert/application_controller"

module RicAdvert
	class Observer::AdvertisersController < ApplicationController
		include RicAdvert::Concerns::Controllers::Observer::AdvertisersController
	end
end
