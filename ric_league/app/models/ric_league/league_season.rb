# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League season
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	class LeagueSeason < ActiveRecord::Base
		include RicLeague::Concerns::Models::LeagueSeason
	end
end
