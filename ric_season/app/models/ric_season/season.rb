# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Season
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

module RicSeason
	class Season < ActiveRecord::Base
		include RicSeason::Concerns::Models::Season
	end
end
