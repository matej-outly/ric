# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document Folders
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "controllers/ric_dms/application_controller"

module RicDms
	class DocumentFoldersController < ApplicationController
		include RicDms::Concerns::Controllers::DocumentFoldersController
	end
end