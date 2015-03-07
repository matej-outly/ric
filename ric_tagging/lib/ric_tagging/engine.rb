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

module RicTagging
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		#require 'ric_tagging/concerns/models/tag'
		
		#
		# Controllers
		#
		#require 'ric_tagging/concerns/controllers/admin/tags_controller'

		isolate_namespace RicTagging
	end
end
