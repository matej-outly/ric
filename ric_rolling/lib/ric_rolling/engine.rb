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
		require 'ric_rolling/concerns/models/user'
		
		#
		# Controllers
		#
		require 'ric_rolling/concerns/controllers/registrations_controller'
		require 'ric_rolling/concerns/controllers/sessions_controller'

		#
		# Mailers
		#
		require 'ric_rolling/concerns/mailers/user_mailer'

		isolate_namespace RicRolling
	end
end
