# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_user/concerns/controllers/admin/users_controller'
		require 'ric_user/concerns/controllers/admin/user_passwords_controller'
		
		isolate_namespace RicUser
	end
end
