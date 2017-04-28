# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuthAdmin
	class Engine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_auth_admin/concerns/controllers/profile_passwords_controller"
		require "ric_auth_admin/concerns/controllers/profiles_controller"
		require "ric_auth_admin/concerns/controllers/sessions_controller"
		
		#
		# Namespace
		#
		isolate_namespace RicAuthAdmin
		
	end
end
