# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_newsletter/concerns/controllers/admin/newsletters_controller'
		require 'ric_newsletter/concerns/controllers/admin/sent_newsletters_controller'
		
		#
		# Namespace
		#
		isolate_namespace RicNewsletter
	end
end
