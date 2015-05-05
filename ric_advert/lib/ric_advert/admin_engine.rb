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
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_advert/concerns/controllers/admin/advertisers_controller'
		require 'ric_advert/concerns/controllers/admin/banners_controller'

		#
		# Namespace
		#
		isolate_namespace RicAdvert
	end
end
