# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League category
# *
# * Author: Matěj Outlý
# * Date  : 14. 1. 2016
# *
# *****************************************************************************

module RicLeague
	class LeagueCategory < ActiveRecord::Base
		include RicLeague::Concerns::Models::LeagueCategory
	end
end
