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

		#
		# Controllers
		#
		require 'ric_contact/concerns/controllers/public/contact_messages_controller'

		isolate_namespace RicContact
	end
end
