# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicDms
	class Engine < ::Rails::Engine

		# Controllers
		require "ric_dms/concerns/controllers/documents_controller"
		require "ric_dms/concerns/controllers/versions_controller"
		require "ric_dms/concerns/controllers/folders_controller"

		# Authorization
		require "ric_dms/concerns/authorization"

		isolate_namespace RicDms

	end
end
