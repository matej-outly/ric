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

require_dependency "ric_dms/application_controller"
require_dependency "ric_dms/document_folders_controller"

module RicDms
	class DocumentFoldersController < ApplicationController
		include RicDms::Concerns::Controllers::DocumentFoldersController
	end
end