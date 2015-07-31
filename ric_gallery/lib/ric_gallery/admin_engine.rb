# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicGallery
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_gallery/concerns/controllers/admin/directories_controller'
		require 'ric_gallery/concerns/controllers/admin/pictures_controller'

		isolate_namespace RicGallery
	end
end
