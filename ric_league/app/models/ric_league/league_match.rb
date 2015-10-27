# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League match
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	class LeagueMatch < ActiveRecord::Base
		include RicLeague::Concerns::Models::LeagueMatch
	end
end
