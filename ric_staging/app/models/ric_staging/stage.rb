# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Stage
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

module RicStaging
	class Stage < ActiveRecord::Base
		include RicStaging::Concerns::Models::Stage
	end
end
