# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicContact
	class PublicEngine < ::Rails::Engine
		
		# Add a load path for this specific engine
  		#config.autoload_paths << File.expand_path("../../app/components", __FILE__)

		#
		# Controllers
		#
		require 'ric_contact/concerns/controllers/public/contact_messages_controller'

		isolate_namespace RicContact
	end
end
