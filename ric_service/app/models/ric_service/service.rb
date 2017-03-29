# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Service
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicService
	class Service < ActiveRecord::Base
		include RicService::Concerns::Models::Service
	end
end
