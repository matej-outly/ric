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
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		#require 'ric_magaazine/concerns/models/article'
		
		#
		# Controllers
		#
		#require 'ric_magaazine/concerns/controllers/admin/articles_controller'

		isolate_namespace RicMagazine
	end
end
