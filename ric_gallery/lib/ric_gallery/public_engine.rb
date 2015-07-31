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
	class PublicEngine < ::Rails::Engine

		#
		# Controllers
		#
		require 'ric_gallery/concerns/controllers/public/directories_controller'

		isolate_namespace RicGallery
	end
end
