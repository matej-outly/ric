# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document Versions
# *
# * Author: Matěj Outlý
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_dms/application_controller"

module RicDms
	class VersionsController < ApplicationController
		include RicDms::Concerns::Controllers::VersionsController
	end
end