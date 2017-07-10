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

module RicNotification
	class Engine < ::Rails::Engine
		
		# Controllers
		require "ric_notification/concerns/controllers/notifications_controller"
		require "ric_notification/concerns/controllers/notification_templates_controller"
		
		isolate_namespace RicNotification		
	end
end
