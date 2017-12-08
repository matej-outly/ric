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

module RicMailboxer
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_mailboxer/concerns/controllers/mailboxes_controller"
		require "ric_mailboxer/concerns/controllers/conversations_controller"
		
		# Namespace
		isolate_namespace RicMailboxer

	end
end
