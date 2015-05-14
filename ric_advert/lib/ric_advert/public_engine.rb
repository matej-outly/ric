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
	class PublicEngine < ::Rails::Engine
		
		engine_name "ric_advert_public"

		#
		# Controllers
		#
		require 'ric_advert/concerns/controllers/public/banners_controller'

		#
		# Namespace
		#
		isolate_namespace RicAdvert
	end
end