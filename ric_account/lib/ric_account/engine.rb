# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAccount
	class Engine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_account/concerns/controllers/account_controller'

		#
		# Namespace
		#
		isolate_namespace RicAccount
	end
end
