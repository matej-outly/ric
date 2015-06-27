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

require_dependency "ric_advert/observer_controller"

module RicAdvert
	class Observer
		class AdvertisersController < ObserverController
			include RicAdvert::Concerns::Controllers::Observer::AdvertisersController
		end
	end
end
