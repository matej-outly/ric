# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author: Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_dms/application_controller"

module RicDms
	class DocumentsController < ApplicationController
		include RicDms::Concerns::Controllers::DocumentsController
	end
end