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

module RicInmail
	class Engine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_inmail/concerns/controllers/messages_controller'
		
		isolate_namespace RicInmail

	end
end
