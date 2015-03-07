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

module RicRolling
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		#require 'ric_rolling/concerns/models/user'
		
		#
		# Controllers
		#
		#require 'ric_rolling/concerns/controllers/admin/users_controller'

		isolate_namespace RicRolling
	end
end
