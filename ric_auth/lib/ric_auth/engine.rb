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

module RicAuth
	class Engine < ::Rails::Engine
		
		#
		# Controllers
		#
		require "ric_auth/concerns/controllers/authentications_controller"
		require "ric_auth/concerns/controllers/overrides_controller"
		require "ric_auth/concerns/controllers/profile_passwords_controller"
		require "ric_auth/concerns/controllers/profiles_controller"
		require "ric_auth/concerns/controllers/sessions_controller"
		
		#
		# Namespace
		#
		isolate_namespace RicAuth

	end
end
