# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicWebsite
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_website/concerns/controllers/admin/texts_controller'
		
		isolate_namespace RicWebsite
	end
end
