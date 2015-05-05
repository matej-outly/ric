# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

module RicMagazine
	class PublicEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_magazine/concerns/controllers/public/articles_controller'

		isolate_namespace RicMagazine
	end
end
