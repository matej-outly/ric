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

module RicContact
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_contact/concerns/controllers/admin/branches_controller'
		
		isolate_namespace RicContact
	end
end
