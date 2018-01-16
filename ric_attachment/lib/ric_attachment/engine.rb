# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicAttachment
	class Engine < ::Rails::Engine

		# Controllers
		require "ric_attachment/concerns/controllers/attachments_controller"
		require "ric_attachment/concerns/controllers/editable_attachments_controller"
		require "ric_attachment/concerns/controllers/froala_controller"
		require "ric_attachment/concerns/controllers/tinymce_controller"
		
		isolate_namespace RicAttachment
	end
end
