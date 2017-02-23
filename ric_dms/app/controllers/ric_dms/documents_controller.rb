# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_dms/documents_controller"

module RicDms
	class DocumentsController < ApplicationController
		include RicDms::Concerns::Controllers::DocumentsController
	end
end