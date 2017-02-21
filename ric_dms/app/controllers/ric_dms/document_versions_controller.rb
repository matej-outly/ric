# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document Versions
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

# require_dependency "controllers/ric_dms/application_controller"

module RicDms
	class DocumentVersionsController < ApplicationController
		include RicDms::Concerns::Controllers::DocumentVersionsController
	end
end