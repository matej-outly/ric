# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	class ObserverEngine < ::Rails::Engine
		
		engine_name "ric_advert_observer"

		#
		# Controllers
		#
		require 'ric_advert/concerns/controllers/observer/advertisers_controller'
		require 'ric_advert/concerns/controllers/observer/banners_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicAdvert
	end
end