# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicDms
	class Engine < ::Rails::Engine

		#
		# Controllers
		#
		require 'ric_dms/concerns/controllers/documents_controller'
		require 'ric_dms/concerns/controllers/document_versions_controller'
		require 'ric_dms/concerns/controllers/document_folders_controller'

		#
		# Authorization
		#
		require 'ric_dms/concerns/authorization'

		isolate_namespace RicDms

	end
end
