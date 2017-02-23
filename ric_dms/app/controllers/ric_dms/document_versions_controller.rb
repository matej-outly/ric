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

require_dependency "ric_dms/document_versions_controller"

module RicDms
	class DocumentVersionsController < ApplicationController
		include RicDms::Concerns::Controllers::DocumentVersionsController
	end
end