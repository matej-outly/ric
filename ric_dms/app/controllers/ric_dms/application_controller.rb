# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_dms/application_controller"

module RicDms
	class ApplicationController < ::ApplicationController
		include RicDms::Concerns::Controllers::Authorization
	end
end