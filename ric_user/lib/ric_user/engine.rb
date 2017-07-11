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
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_user/concerns/controllers/users_controller"
		require "ric_user/concerns/controllers/user_passwords_controller"
		require "ric_user/concerns/controllers/people_selectors_controller"
		require "ric_user/concerns/controllers/sessions_controller"
		
		isolate_namespace RicUser
	end
end
